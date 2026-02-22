# Cloud Armor: Edge Security & WAF (Full Stack)

This module presents a complete, production-ready architecture for protecting web applications in Google Cloud. This is a comprehensive **Defense in Depth** ecosystem.

## 🏗️ Architectural Components

1.  **Global HTTP(S) Load Balancer**: Acts as the entry point (Anycast IP) that receives traffic globally and routes it to the nearest Google region.
2.  **Cloud Armor Security Policy**: An "enhanced WAF" that filters traffic using preconfigured OWASP rules.
3.  **Serverless Network Endpoint Group (NEG)**: A secure way to connect Cloud Run applications to the Load Balancer.
4.  **Ingress: Internal-and-Cloud-Load-Balancing**: A critical Cloud Run configuration that prevents direct connections to the `*.a.run.app` address. All traffic must pass through the WAF.

## 🛡️ Advanced Features in this Demo

### 1. Preconfigured WAF Rules
- `sqli-v33-stable`: Detects and blocks SQL Injection (e.g., `' OR 1=1`).
- `xss-v33-stable`: Detects and blocks Cross-Site Scripting (e.g., `<script>`).

### 2. Rate Limiting (Brute Force Protection)
We implemented a rule that limits requests to **100 per minute per IP**. If this limit is exceeded, the user receives a `429 Too Many Requests` error. This is effective protection against scraping and simple DDoS attacks.

### 3. IP Logging & Monitoring
All blocked requests are logged in Cloud Logging. You can filter them with:
`jsonPayload.enforcedSecurityPolicy.name="secure-edge-waf"`

## 🛠️ How to Verify?
After deploying the infrastructure (Terraform), use the `verify_waf.py` script:
```bash
python verify_waf.py <YOUR_LOAD_BALANCER_IP>
```

---
*Reference: [GCP Cloud Armor Overview](https://cloud.google.com/armor)*
