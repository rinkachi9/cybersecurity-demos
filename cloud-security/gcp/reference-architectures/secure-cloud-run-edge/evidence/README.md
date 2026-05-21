# Evidence: Secure Cloud Run Edge

## Expected Evidence

- Terraform plan or apply summary from a test project.
- Output values for load balancer IP, backend service, Cloud Run service, and Cloud Armor policy.
- Direct `*.run.app` access denied because Cloud Run ingress allows only internal and load-balancer traffic.
- Unauthenticated load balancer access denied or redirected by IAP.
- SQLi and XSS probes blocked by Cloud Armor.
- Cloud Logging query showing `enforcedSecurityPolicy`.

## Suggested Log Queries

Cloud Armor:

```text
resource.type="http_load_balancer"
jsonPayload.enforcedSecurityPolicy.name="secure-cloud-run-edge"
```

IAP:

```text
protoPayload.serviceName="iap.googleapis.com"
protoPayload.methodName:"AuthorizeUser"
```

## Do Not Commit

- OAuth client secrets.
- Production domain ownership details.
- Raw logs containing cookies, bearer tokens, or personal data.

