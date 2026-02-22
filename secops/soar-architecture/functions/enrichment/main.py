import json
import base64
import random
from flask import escape

# Enrichment Function (Mock): Checks usage logs and threat intel
# In a real scenario, this would query Google Cloud Audit Logs or VirusTotal.

def enrich_finding(request):
    request_json = request.get_json(silent=True)
    
    if not request_json:
        return 'Invalid request', 400

    resource_name = request_json.get('resource_name', 'unknown')
    
    # Mock Logic: Simulating Intelligence Analysis
    print(f"[Enrichment] Analyzing resource: {resource_name}")
    
    # Randomly assign a risk score to simulate diverse findings
    # In reality: Check if key was used from a suspicious IP (e.g., Tor Exit Node)
    risk_score = random.randint(50, 95)
    
    is_active = True # Mocking that the key is actively used
    
    response = {
        "risk_score": risk_score,
        "is_active_usage": is_active,
        "source_ip": "203.0.113.5", # Mock Attacker IP
        "geo_location": "Unknown"
    }
    
    print(f"[Enrichment] Result: {json.dumps(response)}")
    return json.dumps(response), 200, {'Content-Type': 'application/json'}
