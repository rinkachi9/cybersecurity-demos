import json
from google.cloud import iam_v1
from google.api_core import exceptions

# Remediation Function: Disables a compromised Service Account Key
# This is the "Automatic Response" part of the SOAR loop.

def remediate_finding(request):
    request_json = request.get_json(silent=True)
    if not request_json:
        return 'Invalid request', 400

    resource_name = request_json.get('resource_name', '')
    
    # resource_name format: projects/-/serviceAccounts/EMAIL/keys/KEY_ID
    # We need to parse this or assume it's passed directly.
    
    print(f"[Remediation] Received request to disable key: {resource_name}")
    
    # In a real environment, we would use the IAM API:
    # client = iam_v1.IAMClient()
    # request = iam_v1.DisableServiceAccountKeyRequest(name=resource_name)
    # try:
    #     client.disable_service_account_key(request=request)
    #     print(f"[Success] Disabled key: {resource_name}")
    #     return "Success: Key Disabled", 200
    # except exceptions.GoogleAPICallError as e:
    #     print(f"[Error] Failed to disable key: {e}")
    #     return f"Failed: {e}", 500

    # For Demo purposes (Simulated Execution):
    action = request_json.get('action', 'NO_OP')
    if action == "DISABLE_KEY":
        print(f"[Simulation] Key {resource_name} has been successfully disabled via IAM API.")
        return json.dumps({"status": "DISABLED", "message": "Key revoked due to high risk"}), 200
    
    return json.dumps({"status": "NO_OP", "message": "No action taken"}), 200
