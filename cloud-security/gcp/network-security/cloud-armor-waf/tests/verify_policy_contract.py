#!/usr/bin/env python3
"""Static contract checks for the Cloud Armor WAF Terraform baseline."""

from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def require_marker(path: Path, marker: str) -> None:
    text = path.read_text(encoding="utf-8")
    if marker not in text:
        raise AssertionError(f"{path.relative_to(ROOT)} missing marker: {marker}")


def main() -> int:
    terraform_dir = ROOT / "terraform"
    main_tf = terraform_dir / "main.tf"
    variables_tf = terraform_dir / "variables.tf"
    outputs_tf = terraform_dir / "outputs.tf"

    for filename in ["main.tf", "versions.tf", "variables.tf", "outputs.tf", "terraform.tfvars.example"]:
        if not (terraform_dir / filename).is_file():
            raise AssertionError(f"terraform/{filename} is required")

    for marker in [
        "google_compute_security_policy",
        "adaptive_protection_config",
        "rate_limit_options",
        "evaluatePreconfiguredExpr",
        "sqli-v33-stable",
        "xss-v33-stable",
        "lfi-v33-stable",
        "rce-v33-stable",
        "preconfigured_waf_rules_preview",
    ]:
        require_marker(main_tf, marker)

    for marker in ["validation {", "custom_rules", "default_rule_action", "enable_rate_based_ban"]:
        require_marker(variables_tf, marker)

    for marker in ["security_policy_self_link", "preconfigured_waf_rule_priorities"]:
        require_marker(outputs_tf, marker)

    print("Cloud Armor WAF policy contract checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
