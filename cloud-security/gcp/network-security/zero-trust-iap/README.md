# Zero Trust Architecture: Identity-Aware Proxy (IAP)

In the traditional "Castle and Moat" model, the internal network is trusted, and the external network is not. An attacker who gains access to the VPN has access to everything. **Zero Trust** assumes the principle: "Never trust, always verify."

## 🛡️ What is IAP?
**Identity-Aware Proxy (IAP)** is a Google Cloud service that acts as a gateway for your applications (HTTPS, SSH, TCP). IAP verifies a user's identity (via Google Identity/IAM) and device context before allowing access.

## 🚀 Key Features

1.  **No VPN Required**: Access internal resources without setting up VPN tunnels.
2.  **Context-Aware Access**: Set conditions like "Access only for employees in the US using a corporate laptop."
3.  **Application-Level Protection**: Even if your application has an authorization flaw, IAP provides a first line of defense at the Load Balancer level.

## 🛠️ How to Implement?
1. Configure an HTTPS Load Balancer.
2. Enable IAP for the appropriate `BackendService`.
3. Configure the OAuth consent screen.
4. Grant the `roles/iap.httpsResourceAccessor` role only to selected users or groups in IAM.

---
*Reference: [GCP IAP Documentation](https://cloud.google.com/iap/docs)*
