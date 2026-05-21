# 08. Web Application Firewall and DDoS Protection

Public web applications are constantly scanned and attacked. A Web Application Firewall helps detect and block common application-layer attacks before they reach the backend. It should complement secure coding, not replace it.

## What is a WAF?

A **Web Application Firewall (WAF)** inspects HTTP and HTTPS requests and applies rules that detect malicious or abusive patterns. It can block or rate-limit requests before they reach the application.

Common WAF protections include:

- SQL injection detection;
- cross-site scripting payload detection;
- path traversal and local file inclusion detection;
- remote code execution signatures;
- protocol and header anomalies;
- IP and geography based rules;
- rate limiting and bot mitigation.

In Google Cloud, **Cloud Armor** provides WAF, L7 DDoS protection, rate limiting, preconfigured OWASP rules, Adaptive Protection, and bot-related controls for workloads behind supported load balancers.

## Architectural context

A WAF should sit at the controlled ingress point. For a typical Google Cloud web architecture:

- users connect to an external HTTPS Load Balancer;
- Cloud Armor policy is attached to the backend service;
- IAP or application authentication protects access where appropriate;
- Cloud Run, GKE, or Compute Engine backends do not allow direct bypass traffic;
- WAF logs are exported to Cloud Logging or a SIEM.

For serverless platforms such as Cloud Run, restricted ingress is important. Otherwise attackers may bypass the load balancer and Cloud Armor by calling the service URL directly.

## Threats and failure modes this protects against

- **SQL injection** attempts against vulnerable endpoints.
- **Cross-site scripting** payloads in parameters, headers, or body content.
- **Path traversal** and local file inclusion probes.
- **Layer 7 DDoS** and abusive request floods.
- **Credential stuffing** and brute force attempts when combined with rate limiting.
- **Automated scanning** from bots and commodity attack tools.
- **Direct backend bypass** if ingress is not restricted.

## Implementation guidance for GCP

1. Put public web applications behind an HTTPS Load Balancer.
2. Attach a Cloud Armor security policy to the backend service.
3. Enable preconfigured WAF rules for OWASP attack categories.
4. Start new rules in preview mode when false positives are likely.
5. Add rate limiting for login, search, and expensive endpoints.
6. Restrict backend ingress so traffic must pass through the load balancer.
7. Export Cloud Armor logs and build alerts for blocked attacks and spikes.
8. Tune exclusions carefully and document why they exist.

## WAF and application security

A WAF reduces exposure but cannot fix broken application logic. It does not replace:

- parameterized SQL queries;
- output encoding;
- CSRF protection;
- authentication and authorization checks;
- secure session handling;
- input validation and business logic controls.

The strongest pattern is secure code plus WAF plus logging plus rate limiting.

## Validation and evidence

Useful evidence includes:

- Cloud Armor policy attached to a backend service;
- WAF rule list and preview/enforcement status;
- test requests for SQLi, XSS, path traversal, and RCE payloads;
- logs showing blocked requests and rule names;
- proof that direct backend access is blocked;
- alert definitions for attack spikes and rate limit triggers.

## Common mistakes

- Enabling WAF rules without preview or false-positive testing.
- Allowing direct access to Cloud Run, GKE, or VM backends.
- Disabling noisy rules instead of tuning exclusions narrowly.
- Not logging WAF decisions.
- Treating WAF as a substitute for secure coding.

## Checklist

- [ ] Public web apps are behind a supported load balancer.
- [ ] Cloud Armor policy is attached to backend services.
- [ ] OWASP preconfigured rules are enabled and tuned.
- [ ] Rate limiting protects sensitive and expensive endpoints.
- [ ] Direct backend bypass is blocked.
- [ ] WAF logs are monitored and alertable.

---
Reference: [Cloud Armor overview](https://cloud.google.com/armor)
