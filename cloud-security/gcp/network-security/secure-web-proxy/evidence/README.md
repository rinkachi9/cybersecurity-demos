# Evidence: Secure Web Proxy

## Expected Evidence

- URL list or FQDN allowlist configuration.
- Successful request to an allowed destination.
- Denied request to a disallowed destination.
- TLS inspection policy status, if enabled.

## Safety Notes

Document TLS inspection exclusions carefully. Some destinations should not be intercepted for legal, privacy, or operational reasons.

