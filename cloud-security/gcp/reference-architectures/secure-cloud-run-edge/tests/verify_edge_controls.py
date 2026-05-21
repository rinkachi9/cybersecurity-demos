#!/usr/bin/env python3
"""Verify deployed Secure Cloud Run Edge controls from an external client."""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass
from urllib import error, parse, request


@dataclass
class ProbeResult:
    name: str
    passed: bool
    status: int | None
    detail: str


class NoRedirectHandler(request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def fetch(url: str) -> tuple[int | None, str]:
    opener = request.build_opener(NoRedirectHandler)
    try:
        response = opener.open(url, timeout=10)
        return response.status, response.read(500).decode("utf-8", errors="replace")
    except error.HTTPError as exc:
        return exc.code, exc.read(500).decode("utf-8", errors="replace")
    except error.URLError as exc:
        return None, str(exc.reason)


def with_query(base_url: str, key: str, value: str) -> str:
    separator = "&" if "?" in base_url else "?"
    return f"{base_url}{separator}{parse.urlencode({key: value})}"


def check_direct_cloud_run_blocked(cloud_run_url: str) -> ProbeResult:
    status, body = fetch(cloud_run_url)
    passed = status in {401, 403, 404} or status is None
    return ProbeResult(
        "direct cloud run access blocked",
        passed,
        status,
        body[:160],
    )


def check_iap_gate(load_balancer_url: str) -> ProbeResult:
    status, body = fetch(load_balancer_url)
    passed = status in {302, 401, 403}
    return ProbeResult(
        "unauthenticated load balancer access gated by IAP",
        passed,
        status,
        body[:160],
    )


def check_waf_probe(load_balancer_url: str, payload: str, name: str) -> ProbeResult:
    status, body = fetch(with_query(load_balancer_url, "q", payload))
    passed = status in {403, 429}
    return ProbeResult(name, passed, status, body[:160])


def print_result(result: ProbeResult) -> None:
    status = result.status if result.status is not None else "connection-error"
    outcome = "PASS" if result.passed else "FAIL"
    print(f"[{outcome}] {result.name}: status={status}")
    if result.detail:
        print(f"  detail: {result.detail}")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Verify Secure Cloud Run Edge controls after deployment.")
    parser.add_argument("--load-balancer-url", required=True, help="HTTPS URL served by the load balancer.")
    parser.add_argument("--cloud-run-url", required=True, help="Default Cloud Run service URL.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    probes = [
        check_direct_cloud_run_blocked(args.cloud_run_url),
        check_iap_gate(args.load_balancer_url),
        check_waf_probe(args.load_balancer_url, "' OR '1'='1", "cloud armor blocks sqli probe"),
        check_waf_probe(args.load_balancer_url, "<script>alert(1)</script>", "cloud armor blocks xss probe"),
    ]

    for probe in probes:
        print_result(probe)

    if all(probe.passed for probe in probes):
        print("\nSecure Cloud Run Edge verification passed.")
        return 0

    print("\nSecure Cloud Run Edge verification failed.")
    return 1


if __name__ == "__main__":
    sys.exit(main())

