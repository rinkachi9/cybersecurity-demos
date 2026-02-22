import base64
import json
from google.cloud import storage

# Cloud Function: Automated GCS Bucket Remediation
# This function is triggered by a Pub/Sub message from SCC.

def remediate_bucket(event, context):
    """
    Triggered from a message on a Cloud Pub/Sub topic.
    The SCC finding contains information about the 'public-bucket'.
    """
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    finding_data = json.loads(pubsub_message)
    
    # Extract the resource name from the finding
    resource_name = finding_data.get('finding', {}).get('resource_name', '')
    
    if "storage.googleapis.com" in resource_name:
        bucket_name = resource_name.split("/")[-1]
        print(f"[!] Alert: Public Bucket detected: {bucket_name}")
        
        try:
            storage_client = storage.Client()
            bucket = storage_client.get_bucket(bucket_name)
            
            # --- Remediation Strategy: Enforce Uniform Bucket-Level Access ---
            # This is the modern way to secure GCS buckets.
            bucket.patch_bucket_iam_policy(
                bucket.get_iam_policy()
            )
            
            # Remove public members (allUsers and allAuthenticatedUsers) from the policy
            policy = bucket.get_iam_policy(requested_policy_version=3)
            modified = False
            
            for binding in policy.bindings:
                if 'allUsers' in binding['members']:
                    binding['members'].remove('allUsers')
                    modified = True
                if 'allAuthenticatedUsers' in binding['members']:
                    binding['members'].remove('allAuthenticatedUsers')
                    modified = True
            
            if modified:
                bucket.set_iam_policy(policy)
                print(f"[SUCCESS] Public access removed from bucket: {bucket_name}")
            else:
                print(f"[INFO] No public members found in bucket policy: {bucket_name}")

        except Exception as e:
            print(f"[ERROR] Could not remediate bucket {bucket_name}: {e}")
    else:
        print("[INFO] Not a GCS resource finding, skipping.")
