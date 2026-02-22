import requests
import sys

# Cloud Armor WAF Verification Tool
# This script sends various payloads to the Load Balancer IP to verify WAF protection.

def verify_waf(lb_ip):
    base_url = f"http://{lb_ip}"
    
    test_cases = [
        {"name": "Legitimate Traffic", "params": {"id": "123"}, "expected": 200},
        {"name": "SQL Injection Attack", "params": {"id": "' OR '1'='1"}, "expected": 403},
        {"name": "XSS Attack", "params": {"id": "<script>alert('XSS')</script>"}, "expected": 403},
        {"name": "Path Traversal", "params": {"file": "../../../etc/passwd"}, "expected": 403},
    ]

    print(f"--- Testing WAF on {base_url} ---")
    
    for test in test_cases:
        try:
            r = requests.get(base_url, params=test["params"])
            status = r.status_code
            result = "PASS" if status == test["expected"] else "FAIL"
            print(f"[{result}] {test['name']:25} | Code: {status} (Expected: {test['expected']})")
        except Exception as e:
            print(f"[ERROR] Could not connect to {base_url}: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python verify_waf.py <LOAD_BALANCER_IP>")
        sys.exit(1)
    
    verify_waf(sys.argv[1])
