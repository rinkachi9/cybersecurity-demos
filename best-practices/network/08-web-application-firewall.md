# 08. Web Application Firewall (WAF) & DDoS Protection

External web applications are the most exposed and attacked part of your infrastructure.

## 🛡️ Architect's Perspective
Senior architects strengthen the security of external web apps using **Cloud Armor**, Google's cloud-native WAF and DDoS protection service. Cloud Armor integrates with the HTTP(S) Load Balancer and provides L7 protection, Rate Limiting, and Bot Management.

### 🚀 Cloud Armor Tiers
1.  **Standard Tier**: Basic WAF and DDoS protection.
2.  **Managed Protection Plus Tier**: For critical workloads, offering advanced DDoS protection, WAF rules for OWASP Top 10, and Bot Management.

### ✅ Checklist for Web Application Security
- [ ] Implement **Cloud Armor** on all HTTPS Load Balancers.
- [ ] Use **reCAPTCHA Enterprise** for bot mitigation and challenge.
- [ ] Enable **Adaptive Protection** (ML-based DDoS detection) on critical endpoints.
- [ ] Implement the **"Internal Ingress"** only mode for Cloud Run to force all traffic through Cloud Armor.

---
*Reference: [GCP Cloud Armor Overview](https://cloud.google.com/armor)*
