#!/usr/bin/env python3
"""Local dry-run checks for the SOAR worker functions."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class FakeRequest:
    def __init__(self, payload):
        self.payload = payload

    def get_json(self, silent=True):
        return self.payload


def load_module(path):
    spec = importlib.util.spec_from_file_location(path.stem, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def assert_enrichment():
    enrichment = load_module(ROOT / "functions" / "enrichment" / "main.py")
    payload = json.loads((ROOT / "sample-events" / "leaked-key-critical.json").read_text(encoding="utf-8"))
    request = FakeRequest(
        {
            "resource_name": payload["finding"]["resourceName"],
            "severity": payload["finding"]["severity"],
            "active_usage": payload["active_usage"],
            "suspicious_source": payload["suspicious_source"],
            "source_ip": payload["source_ip"],
            "dry_run": True,
        }
    )

    body, status, _headers = enrichment.enrich_finding(request)
    result = json.loads(body)

    assert status == 200
    assert result["risk_score"] > 80
    assert result["recommended_action"] == "DISABLE_KEY"
    assert result["dry_run"] is True


def assert_remediation_dry_run():
    remediation = load_module(ROOT / "functions" / "remediation" / "main.py")
    payload = json.loads((ROOT / "sample-events" / "leaked-key-critical.json").read_text(encoding="utf-8"))
    request = FakeRequest(
        {
            "resource_name": payload["finding"]["resourceName"],
            "action": "DISABLE_KEY",
            "dry_run": True,
        }
    )

    body, status, _headers = remediation.remediate_finding(request)
    result = json.loads(body)

    assert status == 200
    assert result["status"] == "DRY_RUN"
    assert result["dry_run"] is True
    assert result["resource_name"] == payload["finding"]["resourceName"]


if __name__ == "__main__":
    assert_enrichment()
    assert_remediation_dry_run()
    print("SOAR dry-run checks passed.")

