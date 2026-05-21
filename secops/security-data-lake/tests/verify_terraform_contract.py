#!/usr/bin/env python3
"""Static contract checks for the Security Data Lake Terraform baseline."""

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
        "google_bigquery_dataset",
        "google_logging_organization_sink",
        "google_logging_folder_sink",
        "google_logging_project_sink",
        "google_bigquery_dataset_iam_member",
        "google_bigquery_data_transfer_config",
        "use_partitioned_tables",
        "replace(file(each.value.query_path)",
    ]:
        require_marker(main_tf, marker)

    for marker in [
        "sink_scope",
        "organization_id",
        "folder_id",
        "log_sink_filter",
        "enable_scheduled_detections",
        "enabled_detection_ids",
        "validation {",
    ]:
        require_marker(variables_tf, marker)

    for marker in ["log_sink_writer_identity", "scheduled_detection_ids", "dataset_self_link"]:
        require_marker(outputs_tf, marker)

    print("Security Data Lake Terraform contract checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
