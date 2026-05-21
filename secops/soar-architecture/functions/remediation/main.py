import json


def disable_service_account_key(resource_name):
    from google.cloud import iam_v1

    client = iam_v1.IAMClient()
    request = iam_v1.DisableServiceAccountKeyRequest(name=resource_name)
    client.disable_service_account_key(request=request)


def build_response(status, resource_name, dry_run, message):
    return {
        "status": status,
        "resource_name": resource_name,
        "dry_run": dry_run,
        "message": message,
    }


def remediate_finding(request):
    request_json = request.get_json(silent=True)
    if not request_json:
        return "Invalid request", 400

    resource_name = request_json.get("resource_name", "")
    action = request_json.get("action", "NO_OP")
    dry_run = bool(request_json.get("dry_run", True))

    print(f"[Remediation] action={action} dry_run={dry_run} resource={resource_name}")

    if action != "DISABLE_KEY":
        response = build_response("NO_OP", resource_name, dry_run, "No remediation action requested.")
        return json.dumps(response), 200, {"Content-Type": "application/json"}

    if not resource_name:
        response = build_response("FAILED", resource_name, dry_run, "Missing resource_name.")
        return json.dumps(response), 400, {"Content-Type": "application/json"}

    if dry_run:
        response = build_response(
            "DRY_RUN",
            resource_name,
            dry_run,
            "Would disable the service account key. No change was made.",
        )
        return json.dumps(response), 200, {"Content-Type": "application/json"}

    try:
        disable_service_account_key(resource_name)
    except Exception as exc:
        response = build_response("FAILED", resource_name, dry_run, f"Failed to disable key: {exc}")
        return json.dumps(response), 500, {"Content-Type": "application/json"}

    response = build_response("DISABLED", resource_name, dry_run, "Service account key disabled.")
    return json.dumps(response), 200, {"Content-Type": "application/json"}

