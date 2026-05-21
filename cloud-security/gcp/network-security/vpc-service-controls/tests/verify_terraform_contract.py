#!/usr/bin/env python3
"""Static contract checks for the VPC Service Controls Terraform baseline."""

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
        "google_access_context_manager_access_policy",
        "google_access_context_manager_access_level",
        "google_access_context_manager_service_perimeter",
        "use_explicit_dry_run_spec",
        "dynamic \"spec\"",
        "egress_policies",
        "ingress_policies",
        "PERIMETER_TYPE_REGULAR",
    ]:
        require_marker(main_tf, marker)

    for marker in [
        "enforcement_mode",
        "dry-run",
        "protected_project_numbers",
        "restricted_services",
        "trusted_ip_subnetworks",
        "current_enforced_project_numbers",
        "validation {",
    ]:
        require_marker(variables_tf, marker)

    for marker in ["service_perimeter_name", "dry_run_spec_enabled", "protected_resources"]:
        require_marker(outputs_tf, marker)

    print("VPC Service Controls Terraform contract checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
