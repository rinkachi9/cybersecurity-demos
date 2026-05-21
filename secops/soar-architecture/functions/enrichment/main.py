import json


SEVERITY_BASE_SCORE = {
    "LOW": 20,
    "MEDIUM": 45,
    "HIGH": 70,
    "CRITICAL": 85,
}


def calculate_risk_score(severity, active_usage, suspicious_source):
    score = SEVERITY_BASE_SCORE.get(str(severity).upper(), 30)
    if active_usage:
        score += 10
    if suspicious_source:
        score += 10
    return min(score, 100)


def build_enrichment(payload):
    severity = payload.get("severity", "LOW")
    resource_name = payload.get("resource_name", "unknown")
    active_usage = bool(payload.get("active_usage", True))
    source_ip = payload.get("source_ip", "203.0.113.5")
    suspicious_source = bool(payload.get("suspicious_source", True))
    dry_run = bool(payload.get("dry_run", True))

    risk_score = calculate_risk_score(severity, active_usage, suspicious_source)
    recommended_action = "DISABLE_KEY" if risk_score > 80 else "CREATE_TICKET"

    return {
        "resource_name": resource_name,
        "severity": severity,
        "risk_score": risk_score,
        "is_active_usage": active_usage,
        "source_ip": source_ip,
        "geo_location": payload.get("geo_location", "Unknown"),
        "recommended_action": recommended_action,
        "dry_run": dry_run,
        "evidence": {
            "active_usage": active_usage,
            "suspicious_source": suspicious_source,
            "risk_model": "severity + active_usage + suspicious_source",
        },
    }


def enrich_finding(request):
    request_json = request.get_json(silent=True)

    if not request_json:
        return "Invalid request", 400

    response = build_enrichment(request_json)

    print(f"[Enrichment] Result: {json.dumps(response)}")
    return json.dumps(response), 200, {"Content-Type": "application/json"}

