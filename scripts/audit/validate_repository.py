#!/usr/bin/env python3
"""Repository quality gate for the cybersecurity demos portfolio."""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path


EXCLUDED_DIRS = {
    ".git",
    ".terraform",
    "__pycache__",
    "node_modules",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
}

REQUIRED_FILES = [
    "README.md",
    "context.md",
    "ROADMAP.md",
    "docs/project-assessment.md",
    "docs/module-standard.md",
    "docs/module-status.md",
    "docs/showcase.md",
    "docs/evidence-matrix.md",
    "docs/demo-script.md",
    "docs/quickstart.md",
    "docs/costs-and-limitations.md",
    "docs/final-acceptance.md",
    "docs/decision-records/README.md",
    "docs/templates/metadata.yaml",
    "docs/templates/runbook.md",
    "docs/templates/evidence.md",
]

KEY_MODULE_READMES = [
    "web-security/owasp-top-10/README.md",
    "cloud-security/gcp/iam-hardening/README.md",
    "cloud-security/gcp/network-security/README.md",
    "cloud-security/gcp/governance/README.md",
    "cloud-security/gcp/incident-response/README.md",
    "cloud-security/gcp/gke-security/README.md",
    "cloud-security/gcp/reference-architectures/README.md",
    "secops/security-data-lake/README.md",
    "secops/soar-architecture/README.md",
    "devsecops/gcp-native-security/README.md",
    "devsecops/gitlab-ci/README.md",
]

STANDARDIZED_MODULE_DIRS = [
    "web-security/owasp-top-10",
    "cloud-security/gcp/iam-hardening/resource-access-management",
    "cloud-security/gcp/iam-hardening/workload-identity-federation",
    "cloud-security/gcp/governance",
    "cloud-security/gcp/incident-response",
    "cloud-security/gcp/data-security/cloud-dlp-demo",
    "cloud-security/gcp/network-security/cloud-armor-waf",
    "cloud-security/gcp/network-security/cloud-ids",
    "cloud-security/gcp/network-security/firewall-policies",
    "cloud-security/gcp/network-security/packet-mirroring",
    "cloud-security/gcp/network-security/secure-web-proxy",
    "cloud-security/gcp/network-security/vpc-service-controls",
    "cloud-security/gcp/network-security/zero-trust-iap",
    "cloud-security/gcp/gke-security",
    "cloud-security/gcp/gke-security/service-mesh",
    "cloud-security/gcp/reference-architectures/secure-cloud-run-edge",
    "secops/security-data-lake",
    "secops/soar-architecture",
    "devsecops/gcp-native-security",
    "devsecops/github-actions/full-pipeline-demo",
    "devsecops/gitlab-ci",
]

TERRAFORM_PRODUCT_DIRS = [
    "cloud-security/gcp/iam-hardening/workload-identity-federation/terraform",
    "cloud-security/gcp/network-security/cloud-armor-waf/terraform",
    "cloud-security/gcp/network-security/cloud-ids/terraform",
    "cloud-security/gcp/network-security/vpc-service-controls/terraform",
    "cloud-security/gcp/reference-architectures/secure-cloud-run-edge/terraform",
    "secops/security-data-lake/terraform",
]

WEB_WORKSHOP_DIR = "web-security/owasp-top-10"
CLOUD_ARMOR_WAF_DIR = "cloud-security/gcp/network-security/cloud-armor-waf"
CLOUD_IDS_DIR = "cloud-security/gcp/network-security/cloud-ids"
VPC_SERVICE_CONTROLS_DIR = "cloud-security/gcp/network-security/vpc-service-controls"
GCP_REFERENCE_ARCHITECTURE_DIR = "cloud-security/gcp/reference-architectures/secure-cloud-run-edge"
DETECTION_ENGINEERING_DIR = "secops/security-data-lake/detections"
SECURITY_DATA_LAKE_DIR = "secops/security-data-lake"
SOAR_ARCHITECTURE_DIR = "secops/soar-architecture"
SUPPLY_CHAIN_DIR = "devsecops/gcp-native-security"

PORTFOLIO_DOCS = [
    "docs/showcase.md",
    "docs/evidence-matrix.md",
    "docs/demo-script.md",
    "docs/quickstart.md",
    "docs/costs-and-limitations.md",
    "docs/final-acceptance.md",
    "docs/decision-records/README.md",
    "docs/decision-records/ADR-001-executable-portfolio.md",
    "docs/decision-records/ADR-002-keyless-cloud-access.md",
    "docs/decision-records/ADR-003-dry-run-remediation.md",
    "docs/decision-records/ADR-004-evidence-first-modules.md",
]

DETECTION_DIRS = [
    "brute-force-login",
    "low-and-slow-beaconing",
    "gcs-data-exfiltration",
]

METADATA_REQUIRED_KEYS = [
    "id",
    "title",
    "domain",
    "level",
    "status",
    "estimated_cost",
    "tools",
    "standards",
    "controls",
    "validation",
    "next_upgrade",
]

LOCAL_LINK_PATTERN = re.compile(r"(?<!!)\[[^\]]+\]\(([^)]+)\)")


@dataclass
class CheckResult:
    name: str
    passed: bool
    details: list[str]
    warnings: list[str]


def iter_files(root: Path, suffixes: tuple[str, ...]) -> list[Path]:
    files: list[Path] = []
    for current_root, dirs, filenames in os.walk(root):
        dirs[:] = [directory for directory in dirs if directory not in EXCLUDED_DIRS]
        current = Path(current_root)
        for filename in filenames:
            path = current / filename
            if path.suffix in suffixes:
                files.append(path)
    return sorted(files)


def rel(root: Path, path: Path) -> str:
    return path.relative_to(root).as_posix()


def check_required_files(root: Path) -> CheckResult:
    missing = [path for path in REQUIRED_FILES if not (root / path).is_file()]
    missing_modules = [path for path in KEY_MODULE_READMES if not (root / path).is_file()]
    details = [f"missing required file: {path}" for path in missing + missing_modules]
    return CheckResult("required files", not details, details, [])


def check_python_syntax(root: Path) -> CheckResult:
    details: list[str] = []
    for path in iter_files(root, (".py",)):
        try:
            source = path.read_text(encoding="utf-8")
            compile(source, str(path), "exec")
        except SyntaxError as exc:
            details.append(f"{rel(root, path)}:{exc.lineno}: {exc.msg}")
    return CheckResult("python syntax", not details, details, [])


def check_javascript_syntax(root: Path) -> CheckResult:
    node = shutil.which("node")
    if not node:
        return CheckResult("javascript syntax", True, [], ["node not found; JS syntax check skipped"])

    details: list[str] = []
    for path in iter_files(root, (".js",)):
        completed = subprocess.run(
            [node, "--check", str(path)],
            cwd=root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        if completed.returncode != 0:
            output = completed.stderr.strip() or completed.stdout.strip()
            details.append(f"{rel(root, path)}: {output}")
    return CheckResult("javascript syntax", not details, details, [])


def normalize_markdown_target(raw_target: str) -> str | None:
    target = raw_target.strip()
    if not target:
        return None
    if target.startswith(("http://", "https://", "mailto:", "#")):
        return None
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    return target.split("#", 1)[0]


def check_markdown_links(root: Path) -> CheckResult:
    details: list[str] = []
    for markdown in iter_files(root, (".md",)):
        text = markdown.read_text(encoding="utf-8")
        for match in LOCAL_LINK_PATTERN.finditer(text):
            target = normalize_markdown_target(match.group(1))
            if not target:
                continue
            candidate = (markdown.parent / target).resolve()
            try:
                candidate.relative_to(root.resolve())
            except ValueError:
                details.append(f"{rel(root, markdown)}: link escapes repo: {match.group(1)}")
                continue
            if not candidate.exists():
                details.append(f"{rel(root, markdown)}: broken link: {match.group(1)}")
    return CheckResult("markdown links", not details, details, [])


def check_terraform_structure(root: Path) -> CheckResult:
    details: list[str] = []
    warnings: list[str] = []
    terraform_dirs = sorted({path.parent for path in iter_files(root, (".tf",))})

    for directory in terraform_dirs:
        if not (directory / "main.tf").is_file():
            details.append(f"{rel(root, directory)}: missing main.tf")
        module_readme = directory.parent / "README.md"
        local_readme = directory / "README.md"
        if not module_readme.is_file() and not local_readme.is_file():
            details.append(f"{rel(root, directory)}: missing README.md in module parent or directory")

        combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted(directory.glob("*.tf")))
        if "YOUR_" in combined or "yourdomain.com" in combined or "your-" in combined:
            warnings.append(f"{rel(root, directory)}: demo placeholders remain; migrate to variables in roadmap stage 3")
        if "required_providers" not in combined:
            warnings.append(f"{rel(root, directory)}: required_providers not declared yet")

    return CheckResult("terraform structure", not details, details, warnings)


def check_terraform_product_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    warnings: list[str] = []
    required_files = ["main.tf", "versions.tf", "variables.tf", "outputs.tf", "terraform.tfvars.example"]

    for module_dir in TERRAFORM_PRODUCT_DIRS:
        directory = root / module_dir
        for filename in required_files:
            if not (directory / filename).is_file():
                details.append(f"{module_dir}: missing {filename}")

        if not (directory.parent / "examples" / "minimal" / "main.tf").is_file():
            details.append(f"{module_dir}: missing examples/minimal/main.tf")

        combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted(directory.glob("*.tf")))
        if "required_version" not in combined:
            details.append(f"{module_dir}: required_version not declared")
        if "required_providers" not in combined:
            details.append(f"{module_dir}: required_providers not declared")
        if "validation {" not in combined:
            warnings.append(f"{module_dir}: no variable validation blocks found")
        if "YOUR_" in combined or "yourdomain.com" in combined:
            details.append(f"{module_dir}: unresolved placeholder remains")

    return CheckResult("terraform product baseline", not details, details, warnings)


def check_final_static_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    terraform_dirs = sorted({path.parent for path in iter_files(root, (".tf",)) if path.parent.name == "terraform"})

    for directory in terraform_dirs:
        module_dir = rel(root, directory)
        for filename in ["main.tf", "versions.tf", "variables.tf", "outputs.tf"]:
            if not (directory / filename).is_file():
                details.append(f"{module_dir}: final baseline missing {filename}")

        combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted(directory.glob("*.tf")))
        for marker in ["YOUR_", "yourdomain.com", "your-"]:
            if marker in combined:
                details.append(f"{module_dir}: final baseline contains placeholder `{marker}`")
        if "required_providers" not in combined:
            details.append(f"{module_dir}: final baseline missing required_providers")

    final_acceptance = (root / "docs" / "final-acceptance.md").read_text(encoding="utf-8")
    for marker in [
        "Final source-control baseline",
        "Completed static controls",
        "Final quality bar",
        "Runtime evidence boundary",
    ]:
        if marker not in final_acceptance:
            details.append(f"docs/final-acceptance.md: missing `{marker}`")

    return CheckResult("final static baseline", not details, details, [])


def check_web_workshop_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / WEB_WORKSHOP_DIR
    required_files = [
        "Dockerfile",
        ".dockerignore",
        "docker-compose.yml",
        "tests/requirements.txt",
        "tests/poc_exploits.py",
        "src/app.js",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{WEB_WORKSHOP_DIR}: missing {filename}")

    package_json = (module / "package.json").read_text(encoding="utf-8")
    for script in ["poc:vulnerable", "poc:workshop-secure", "workshop:test"]:
        if f'"{script}"' not in package_json:
            details.append(f"{WEB_WORKSHOP_DIR}/package.json: missing npm script `{script}`")

    app_js = (module / "src" / "app.js").read_text(encoding="utf-8")
    for marker in ["/health", "/api/profiles/:id", "SECURE_MODE"]:
        if marker not in app_js:
            details.append(f"{WEB_WORKSHOP_DIR}/src/app.js: missing `{marker}` workshop marker")

    poc = (module / "tests" / "poc_exploits.py").read_text(encoding="utf-8")
    for marker in ["test_idor", "--wait", "--expect"]:
        if marker not in poc:
            details.append(f"{WEB_WORKSHOP_DIR}/tests/poc_exploits.py: missing `{marker}`")

    compose = (module / "docker-compose.yml").read_text(encoding="utf-8")
    for marker in ["owasp-vulnerable", "owasp-secure", "3000:3000", "3001:3000"]:
        if marker not in compose:
            details.append(f"{WEB_WORKSHOP_DIR}/docker-compose.yml: missing `{marker}`")

    return CheckResult("web workshop baseline", not details, details, [])


def check_cloud_armor_waf_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / CLOUD_ARMOR_WAF_DIR
    required_files = [
        "README.md",
        "metadata.yaml",
        "runbook.md",
        "evidence/README.md",
        "verify_waf.py",
        "tests/verify_policy_contract.py",
        "terraform/main.tf",
        "terraform/versions.tf",
        "terraform/variables.tf",
        "terraform/outputs.tf",
        "terraform/terraform.tfvars.example",
        "examples/minimal/main.tf",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{CLOUD_ARMOR_WAF_DIR}: missing {filename}")

    terraform_main = (module / "terraform" / "main.tf").read_text(encoding="utf-8")
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
        if marker not in terraform_main:
            details.append(f"{CLOUD_ARMOR_WAF_DIR}/terraform/main.tf: missing `{marker}`")

    variables = (module / "terraform" / "variables.tf").read_text(encoding="utf-8")
    for marker in ["validation {", "custom_rules", "enable_rate_limiting", "enable_rate_based_ban"]:
        if marker not in variables:
            details.append(f"{CLOUD_ARMOR_WAF_DIR}/terraform/variables.tf: missing `{marker}`")

    outputs = (module / "terraform" / "outputs.tf").read_text(encoding="utf-8")
    for marker in ["security_policy_self_link", "preconfigured_waf_rule_priorities"]:
        if marker not in outputs:
            details.append(f"{CLOUD_ARMOR_WAF_DIR}/terraform/outputs.tf: missing `{marker}`")

    verifier = (module / "verify_waf.py").read_text(encoding="utf-8")
    for marker in ["urlopen", "sql injection", "cross-site scripting", "path traversal", "remote code execution"]:
        if marker not in verifier:
            details.append(f"{CLOUD_ARMOR_WAF_DIR}/verify_waf.py: missing `{marker}`")
    if "import requests" in verifier:
        details.append(f"{CLOUD_ARMOR_WAF_DIR}/verify_waf.py: external requests dependency should not be required")

    contract = (module / "tests" / "verify_policy_contract.py").read_text(encoding="utf-8")
    if "Cloud Armor WAF policy contract checks passed." not in contract:
        details.append(f"{CLOUD_ARMOR_WAF_DIR}/tests/verify_policy_contract.py: missing success marker")

    return CheckResult("cloud armor waf baseline", not details, details, [])


def check_cloud_ids_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / CLOUD_IDS_DIR
    required_files = [
        "README.md",
        "metadata.yaml",
        "runbook.md",
        "evidence/README.md",
        "tests/verify_terraform_contract.py",
        "terraform/main.tf",
        "terraform/versions.tf",
        "terraform/variables.tf",
        "terraform/outputs.tf",
        "terraform/terraform.tfvars.example",
        "examples/minimal/main.tf",
        "examples/minimal/README.md",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{CLOUD_IDS_DIR}: missing {filename}")

    terraform_main = (module / "terraform" / "main.tf").read_text(encoding="utf-8")
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
        if marker not in terraform_main:
            details.append(f"{CLOUD_IDS_DIR}/terraform/main.tf: missing `{marker}`")

    variables = (module / "terraform" / "variables.tf").read_text(encoding="utf-8")
    for marker in [
        "minimum_threat_severity",
        "enable_packet_mirroring",
        "mirrored_subnetwork_self_links",
        "mirrored_cidr_ranges",
        "mirroring_direction",
        "private_service_range_prefix_length",
        "validation {",
    ]:
        if marker not in variables:
            details.append(f"{CLOUD_IDS_DIR}/terraform/variables.tf: missing `{marker}`")

    outputs = (module / "terraform" / "outputs.tf").read_text(encoding="utf-8")
    for marker in ["ids_endpoint_forwarding_rule", "packet_mirroring_policy_name", "reserved_peering_ranges"]:
        if marker not in outputs:
            details.append(f"{CLOUD_IDS_DIR}/terraform/outputs.tf: missing `{marker}`")

    contract = (module / "tests" / "verify_terraform_contract.py").read_text(encoding="utf-8")
    if "Cloud IDS Terraform contract checks passed." not in contract:
        details.append(f"{CLOUD_IDS_DIR}/tests/verify_terraform_contract.py: missing success marker")

    combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted((module / "terraform").glob("*.tf")))
    if "YOUR_" in combined or "YOUR_PROJECT_ID" in combined or "YOUR_VPC" in combined:
        details.append(f"{CLOUD_IDS_DIR}/terraform: unresolved placeholder remains")

    return CheckResult("cloud ids baseline", not details, details, [])


def check_vpc_service_controls_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / VPC_SERVICE_CONTROLS_DIR
    required_files = [
        "README.md",
        "metadata.yaml",
        "runbook.md",
        "evidence/README.md",
        "tests/verify_terraform_contract.py",
        "terraform/main.tf",
        "terraform/versions.tf",
        "terraform/variables.tf",
        "terraform/outputs.tf",
        "terraform/terraform.tfvars.example",
        "examples/minimal/main.tf",
        "examples/minimal/README.md",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{VPC_SERVICE_CONTROLS_DIR}: missing {filename}")

    terraform_main = (module / "terraform" / "main.tf").read_text(encoding="utf-8")
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
        if marker not in terraform_main:
            details.append(f"{VPC_SERVICE_CONTROLS_DIR}/terraform/main.tf: missing `{marker}`")

    variables = (module / "terraform" / "variables.tf").read_text(encoding="utf-8")
    for marker in [
        "enforcement_mode",
        "dry-run",
        "protected_project_numbers",
        "restricted_services",
        "trusted_ip_subnetworks",
        "current_enforced_project_numbers",
        "validation {",
    ]:
        if marker not in variables:
            details.append(f"{VPC_SERVICE_CONTROLS_DIR}/terraform/variables.tf: missing `{marker}`")

    outputs = (module / "terraform" / "outputs.tf").read_text(encoding="utf-8")
    for marker in ["service_perimeter_name", "dry_run_spec_enabled", "protected_resources"]:
        if marker not in outputs:
            details.append(f"{VPC_SERVICE_CONTROLS_DIR}/terraform/outputs.tf: missing `{marker}`")

    contract = (module / "tests" / "verify_terraform_contract.py").read_text(encoding="utf-8")
    if "VPC Service Controls Terraform contract checks passed." not in contract:
        details.append(f"{VPC_SERVICE_CONTROLS_DIR}/tests/verify_terraform_contract.py: missing success marker")

    combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted((module / "terraform").glob("*.tf")))
    if "YOUR_" in combined or "YOUR_ORG_ID" in combined or "YOUR_PROJECT_ID" in combined:
        details.append(f"{VPC_SERVICE_CONTROLS_DIR}/terraform: unresolved placeholder remains")

    return CheckResult("vpc service controls baseline", not details, details, [])


def check_gcp_reference_architecture_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / GCP_REFERENCE_ARCHITECTURE_DIR
    required_files = [
        "README.md",
        "metadata.yaml",
        "runbook.md",
        "architecture.mmd",
        "evidence/README.md",
        "tests/verify_edge_controls.py",
        "terraform/main.tf",
        "terraform/versions.tf",
        "terraform/variables.tf",
        "terraform/outputs.tf",
        "terraform/terraform.tfvars.example",
        "examples/minimal/main.tf",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{GCP_REFERENCE_ARCHITECTURE_DIR}: missing {filename}")

    terraform_main = (module / "terraform" / "main.tf").read_text(encoding="utf-8")
    for marker in [
        "google_cloud_run_v2_service",
        "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER",
        "google_compute_security_policy",
        "google_compute_backend_service",
        "google_iap_web_backend_service_iam_member",
        "google_compute_region_network_endpoint_group",
        "google_compute_global_forwarding_rule",
    ]:
        if marker not in terraform_main:
            details.append(f"{GCP_REFERENCE_ARCHITECTURE_DIR}/terraform/main.tf: missing `{marker}`")

    verify_script = (module / "tests" / "verify_edge_controls.py").read_text(encoding="utf-8")
    for marker in ["direct cloud run access blocked", "gated by IAP", "blocks sqli", "blocks xss"]:
        if marker not in verify_script:
            details.append(f"{GCP_REFERENCE_ARCHITECTURE_DIR}/tests/verify_edge_controls.py: missing `{marker}`")

    return CheckResult("gcp reference architecture baseline", not details, details, [])


def parse_json_file(path: Path, root: Path, details: list[str]) -> None:
    try:
        json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        details.append(f"{rel(root, path)}:{exc.lineno}: invalid JSON: {exc.msg}")


def check_detection_engineering_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    detection_root = root / DETECTION_ENGINEERING_DIR

    if not (detection_root / "manifest.yaml").is_file():
        details.append(f"{DETECTION_ENGINEERING_DIR}: missing manifest.yaml")

    for detection in DETECTION_DIRS:
        directory = detection_root / detection
        required_files = ["README.md", "metadata.yaml", "query.sql", "sample-events.json", "expected-result.json"]
        for filename in required_files:
            if not (directory / filename).is_file():
                details.append(f"{DETECTION_ENGINEERING_DIR}/{detection}: missing {filename}")

        if not directory.is_dir():
            continue

        metadata = (directory / "metadata.yaml").read_text(encoding="utf-8")
        for marker in ["id:", "data_sources:", "mitre_attack:", "false_positives:", "tuning:"]:
            if marker not in metadata:
                details.append(f"{DETECTION_ENGINEERING_DIR}/{detection}/metadata.yaml: missing `{marker}`")

        query = (directory / "query.sql").read_text(encoding="utf-8")
        for marker in ["SELECT", "FROM", "security_data_lake"]:
            if marker not in query:
                details.append(f"{DETECTION_ENGINEERING_DIR}/{detection}/query.sql: missing `{marker}`")

        parse_json_file(directory / "sample-events.json", root, details)
        parse_json_file(directory / "expected-result.json", root, details)

    return CheckResult("detection engineering baseline", not details, details, [])


def check_security_data_lake_terraform_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / SECURITY_DATA_LAKE_DIR
    required_files = [
        "README.md",
        "metadata.yaml",
        "runbook.md",
        "evidence/README.md",
        "tests/verify_terraform_contract.py",
        "terraform/main.tf",
        "terraform/versions.tf",
        "terraform/variables.tf",
        "terraform/outputs.tf",
        "terraform/terraform.tfvars.example",
        "examples/minimal/main.tf",
        "examples/minimal/README.md",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{SECURITY_DATA_LAKE_DIR}: missing {filename}")

    terraform_main = (module / "terraform" / "main.tf").read_text(encoding="utf-8")
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
        if marker not in terraform_main:
            details.append(f"{SECURITY_DATA_LAKE_DIR}/terraform/main.tf: missing `{marker}`")

    variables = (module / "terraform" / "variables.tf").read_text(encoding="utf-8")
    for marker in [
        "sink_scope",
        "organization_id",
        "folder_id",
        "log_sink_filter",
        "enable_scheduled_detections",
        "enabled_detection_ids",
        "validation {",
    ]:
        if marker not in variables:
            details.append(f"{SECURITY_DATA_LAKE_DIR}/terraform/variables.tf: missing `{marker}`")

    outputs = (module / "terraform" / "outputs.tf").read_text(encoding="utf-8")
    for marker in ["log_sink_writer_identity", "scheduled_detection_ids", "dataset_self_link"]:
        if marker not in outputs:
            details.append(f"{SECURITY_DATA_LAKE_DIR}/terraform/outputs.tf: missing `{marker}`")

    contract = (module / "tests" / "verify_terraform_contract.py").read_text(encoding="utf-8")
    if "Security Data Lake Terraform contract checks passed." not in contract:
        details.append(f"{SECURITY_DATA_LAKE_DIR}/tests/verify_terraform_contract.py: missing success marker")

    combined = "\n".join(path.read_text(encoding="utf-8") for path in sorted((module / "terraform").glob("*.tf")))
    if "YOUR_" in combined or "YOUR_ORG_ID" in combined or "YOUR_PROJECT_ID" in combined:
        details.append(f"{SECURITY_DATA_LAKE_DIR}/terraform: unresolved placeholder remains")

    return CheckResult("security data lake terraform baseline", not details, details, [])


def check_soar_dry_run_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / SOAR_ARCHITECTURE_DIR
    required_files = [
        "sample-events/leaked-key-critical.json",
        "sample-events/leaked-key-medium.json",
        "expected-results/leaked-key-critical-dry-run.json",
        "expected-results/leaked-key-medium-ticket.json",
        "tests/test_dry_run.py",
        "functions/enrichment/main.py",
        "functions/remediation/main.py",
        "workflows/leaked_key_playbook.yaml",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{SOAR_ARCHITECTURE_DIR}: missing {filename}")

    for filename in required_files:
        if filename.endswith(".json") and (module / filename).is_file():
            parse_json_file(module / filename, root, details)

    enrichment = (module / "functions" / "enrichment" / "main.py").read_text(encoding="utf-8")
    for marker in ["calculate_risk_score", "recommended_action", "dry_run"]:
        if marker not in enrichment:
            details.append(f"{SOAR_ARCHITECTURE_DIR}/functions/enrichment/main.py: missing `{marker}`")

    remediation = (module / "functions" / "remediation" / "main.py").read_text(encoding="utf-8")
    for marker in ["dry_run", "DRY_RUN", "disable_service_account_key"]:
        if marker not in remediation:
            details.append(f"{SOAR_ARCHITECTURE_DIR}/functions/remediation/main.py: missing `{marker}`")

    workflow = (module / "workflows" / "leaked_key_playbook.yaml").read_text(encoding="utf-8")
    for marker in ["SOAR_DRY_RUN", "dry_run", "DISABLE_KEY"]:
        if marker not in workflow:
            details.append(f"{SOAR_ARCHITECTURE_DIR}/workflows/leaked_key_playbook.yaml: missing `{marker}`")

    return CheckResult("soar dry-run baseline", not details, details, [])


def check_supply_chain_baseline(root: Path) -> CheckResult:
    details: list[str] = []
    module = root / SUPPLY_CHAIN_DIR
    required_files = [
        "cloud-build/secure-supply-chain.yaml",
        "cloud-build/secure-pipeline.yaml",
        "supply-chain/README.md",
        "policies/admission-policy.yaml",
        "provenance/slsa-provenance.example.json",
        "attestations/binauthz-attestation-payload.example.json",
        "runbook.md",
        "evidence/README.md",
        "metadata.yaml",
    ]

    for filename in required_files:
        if not (module / filename).is_file():
            details.append(f"{SUPPLY_CHAIN_DIR}: missing {filename}")

    for filename in ["provenance/slsa-provenance.example.json", "attestations/binauthz-attestation-payload.example.json"]:
        path = module / filename
        if path.is_file():
            parse_json_file(path, root, details)

    pipeline = (module / "cloud-build" / "secure-supply-chain.yaml").read_text(encoding="utf-8")
    for marker in ["generate-sbom", "sbom.spdx.json", "trivy.sarif", "vulnerability-gate", "sign-and-create", "binauthz"]:
        if marker not in pipeline:
            details.append(f"{SUPPLY_CHAIN_DIR}/cloud-build/secure-supply-chain.yaml: missing `{marker}`")
    if ":latest" in pipeline:
        details.append(f"{SUPPLY_CHAIN_DIR}/cloud-build/secure-supply-chain.yaml: floating latest tag is not allowed")

    policy = (module / "policies" / "admission-policy.yaml").read_text(encoding="utf-8")
    for marker in ["sbom:", "vulnerability_scan:", "provenance:", "attestation:", "default_admission: deny"]:
        if marker not in policy:
            details.append(f"{SUPPLY_CHAIN_DIR}/policies/admission-policy.yaml: missing `{marker}`")

    codeowners = root / ".github" / "CODEOWNERS"
    if not codeowners.is_file():
        details.append(".github/CODEOWNERS: missing supply-chain ownership gate")
    else:
        codeowners_text = codeowners.read_text(encoding="utf-8")
        for marker in ["/devsecops/", "/cloud-security/", "/.github/workflows/"]:
            if marker not in codeowners_text:
                details.append(f".github/CODEOWNERS: missing `{marker}` owner rule")

    github_template = root / "devsecops" / "github-actions" / "templates" / "sbom-and-sarif.yml"
    if not github_template.is_file():
        details.append("devsecops/github-actions/templates/sbom-and-sarif.yml: missing")
    else:
        workflow = github_template.read_text(encoding="utf-8")
        for marker in ["anchore/sbom-action", "aquasecurity/trivy-action", "upload-sarif", "upload-artifact"]:
            if marker not in workflow:
                details.append(f"devsecops/github-actions/templates/sbom-and-sarif.yml: missing `{marker}`")

    return CheckResult("supply chain baseline", not details, details, [])


def check_portfolio_baseline(root: Path) -> CheckResult:
    details: list[str] = []

    for filename in PORTFOLIO_DOCS:
        if not (root / filename).is_file():
            details.append(f"portfolio baseline: missing {filename}")

    showcase = (root / "docs" / "showcase.md").read_text(encoding="utf-8")
    for marker in [
        "Five minute read path",
        "Thirty minute presentation",
        "Sixty minute technical walkthrough",
        "Ninety minute expert review",
        "attack -> control -> detection -> response -> evidence",
    ]:
        if marker not in showcase:
            details.append(f"docs/showcase.md: missing `{marker}`")

    evidence = (root / "docs" / "evidence-matrix.md").read_text(encoding="utf-8")
    for marker in [
        "Evidence levels",
        "Cross-domain evidence chain",
        "OWASP Top 10 Lab",
        "Secure Cloud Run Edge",
        "GCP Native Supply Chain",
    ]:
        if marker not in evidence:
            details.append(f"docs/evidence-matrix.md: missing `{marker}`")

    demo_script = (root / "docs" / "demo-script.md").read_text(encoding="utf-8")
    for marker in [
        "python3 scripts/audit/validate_repository.py",
        "python3 secops/soar-architecture/tests/test_dry_run.py",
        "Docker is optional and not required",
        "GCP credentials are optional and not required",
    ]:
        if marker not in demo_script:
            details.append(f"docs/demo-script.md: missing `{marker}`")

    quickstart = (root / "docs" / "quickstart.md").read_text(encoding="utf-8")
    for marker in ["Local validation", "SOAR dry-run", "Review-only paths", "Optional runtime paths"]:
        if marker not in quickstart:
            details.append(f"docs/quickstart.md: missing `{marker}`")

    adr_index = (root / "docs" / "decision-records" / "README.md").read_text(encoding="utf-8")
    for marker in ["ADR-001", "ADR-002", "ADR-003", "ADR-004"]:
        if marker not in adr_index:
            details.append(f"docs/decision-records/README.md: missing `{marker}`")

    final_acceptance = (root / "docs" / "final-acceptance.md").read_text(encoding="utf-8")
    for marker in ["Final source-control baseline", "Runtime evidence boundary"]:
        if marker not in final_acceptance:
            details.append(f"docs/final-acceptance.md: missing `{marker}`")

    return CheckResult("portfolio baseline", not details, details, [])


def metadata_has_key(metadata: str, key: str) -> bool:
    return re.search(rf"^{re.escape(key)}\s*:", metadata, flags=re.MULTILINE) is not None


def metadata_flag(metadata: str, flag: str) -> bool:
    return re.search(rf"^\s*{re.escape(flag)}\s*:\s*true\s*$", metadata, flags=re.MULTILINE) is not None


def check_module_standard(root: Path) -> CheckResult:
    details: list[str] = []
    warnings: list[str] = []

    for module_dir in STANDARDIZED_MODULE_DIRS:
        directory = root / module_dir
        metadata_path = directory / "metadata.yaml"
        readme_path = directory / "README.md"

        if not directory.is_dir():
            details.append(f"{module_dir}: module directory missing")
            continue
        if not readme_path.is_file():
            details.append(f"{module_dir}: README.md missing")
        if not metadata_path.is_file():
            details.append(f"{module_dir}: metadata.yaml missing")
            continue

        metadata = metadata_path.read_text(encoding="utf-8")
        missing_keys = [key for key in METADATA_REQUIRED_KEYS if not metadata_has_key(metadata, key)]
        for key in missing_keys:
            details.append(f"{module_dir}/metadata.yaml: missing key `{key}`")

        if metadata_flag(metadata, "evidence_required") and not (directory / "evidence" / "README.md").is_file():
            details.append(f"{module_dir}: evidence/README.md required by metadata")
        if metadata_flag(metadata, "runbook_required") and not (directory / "runbook.md").is_file():
            details.append(f"{module_dir}: runbook.md required by metadata")
        if not metadata_flag(metadata, "evidence_required"):
            warnings.append(f"{module_dir}: evidence capture not yet required")

    return CheckResult("module standard", not details, details, warnings)


def print_result(result: CheckResult) -> None:
    status = "PASS" if result.passed else "FAIL"
    print(f"[{status}] {result.name}")
    for detail in result.details:
        print(f"  - {detail}")
    for warning in result.warnings:
        print(f"  - WARN: {warning}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate repository structure and lightweight syntax checks.")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2])
    args = parser.parse_args()

    root = args.root.resolve()
    checks = [
        check_required_files(root),
        check_python_syntax(root),
        check_javascript_syntax(root),
        check_markdown_links(root),
        check_terraform_structure(root),
        check_terraform_product_baseline(root),
        check_final_static_baseline(root),
        check_web_workshop_baseline(root),
        check_cloud_armor_waf_baseline(root),
        check_cloud_ids_baseline(root),
        check_vpc_service_controls_baseline(root),
        check_gcp_reference_architecture_baseline(root),
        check_detection_engineering_baseline(root),
        check_security_data_lake_terraform_baseline(root),
        check_soar_dry_run_baseline(root),
        check_supply_chain_baseline(root),
        check_portfolio_baseline(root),
        check_module_standard(root),
    ]

    for result in checks:
        print_result(result)

    failed = [result.name for result in checks if not result.passed]
    if failed:
        print(f"\nRepository validation failed: {', '.join(failed)}")
        return 1

    print("\nRepository validation passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
