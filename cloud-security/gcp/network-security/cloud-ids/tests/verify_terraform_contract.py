#!/usr/bin/env python3
"""Static contract checks for the Cloud IDS Terraform baseline."""

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
        "google_cloud_ids_endpoint",
        "google_compute_packet_mirroring",
        "google_compute_global_address",
        "google_service_networking_connection",
        "collector_ilb",
        "endpoint_forwarding_rule",
        "mirrored_resources",
        "filter",
    ]:
        require_marker(main_tf, marker)

    for marker in [
        "minimum_threat_severity",
        "enable_packet_mirroring",
        "mirrored_subnetwork_self_links",
        "mirrored_cidr_ranges",
        "mirroring_direction",
        "private_service_range_prefix_length",
        "validation {",
    ]:
        require_marker(variables_tf, marker)

    for marker in ["ids_endpoint_forwarding_rule", "packet_mirroring_policy_name", "reserved_peering_ranges"]:
        require_marker(outputs_tf, marker)

    print("Cloud IDS Terraform contract checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
