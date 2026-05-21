#!/usr/bin/env python3
"""Cloud Armor WAF verification helper.

The script uses only the Python standard library so it can run in constrained
review environments. Run it against a load balancer endpoint, not a direct
backend URL.
"""

from __future__ import annotations

import argparse
import sys
from dataclasses import dataclass
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


@dataclass(frozen=True)
class TestCase:
    name: str
    params: dict[str, str]
    expected_status: int


TEST_CASES = [
    TestCase("legitimate traffic", {"id": "123"}, 200),
    TestCase("sql injection", {"id": "' OR '1'='1"}, 403),
    TestCase("cross-site scripting", {"id": "<script>alert('xss')</script>"}, 403),
    TestCase("path traversal", {"file": "../../../etc/passwd"}, 403),
    TestCase("remote code execution", {"cmd": ";cat /etc/passwd"}, 403),
]


def build_base_url(target: str, scheme: str) -> str:
    if target.startswith(("http://", "https://")):
        return target.rstrip("/")
    return f"{scheme}://{target.rstrip('/')}"


def fetch_status(url: str, timeout: float) -> int:
    request = Request(url, headers={"User-Agent": "cloud-armor-waf-verifier/1.0"})
    try:
        with urlopen(request, timeout=timeout) as response:
            return int(response.status)
    except HTTPError as exc:
        return int(exc.code)


def run_checks(base_url: str, path: str, timeout: float) -> bool:
    normalized_path = path if path.startswith("/") else f"/{path}"
    passed = True
    print(f"--- Testing WAF on {base_url}{normalized_path} ---")

    for test in TEST_CASES:
        query = urlencode(test.params)
        url = f"{base_url}{normalized_path}?{query}"
        try:
            status = fetch_status(url, timeout)
        except URLError as exc:
            print(f"[ERROR] {test.name:24} | connection failed: {exc.reason}")
            passed = False
            continue

        result = "PASS" if status == test.expected_status else "FAIL"
        if result == "FAIL":
            passed = False
        print(f"[{result}] {test.name:24} | code: {status} expected: {test.expected_status}")

    return passed


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Verify Cloud Armor WAF behavior through a load balancer.")
    parser.add_argument("target", help="Load balancer host, IP, or full URL.")
    parser.add_argument("--scheme", choices=["http", "https"], default="https", help="Scheme used when target has no scheme.")
    parser.add_argument("--path", default="/", help="Request path to test.")
    parser.add_argument("--timeout", type=float, default=5.0, help="HTTP timeout in seconds.")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    base_url = build_base_url(args.target, args.scheme)
    return 0 if run_checks(base_url, args.path, args.timeout) else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
