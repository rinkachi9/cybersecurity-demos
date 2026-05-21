# Lab: OWASP Top 10 Mitigation

This module is a workshop-style web security lab for comparing intentionally vulnerable Express.js behavior with mitigated behavior. It is designed to show attack, defense, and automated validation side by side.

## Threat Model

The lab models a small API that accepts user-controlled input, exposes administrative data, and serves user-owned objects. The attacker is an unauthenticated internet user or a low-privilege authenticated user trying to:

- manipulate SQL queries,
- inject script into HTML responses,
- read admin-only configuration,
- access another user's profile object by changing an ID.

## Quickstart: Docker Compose

Run both modes:

```bash
cd web-security/owasp-top-10
docker compose up --build
```

Endpoints:

- Vulnerable mode: `http://localhost:3000`
- Secure mode: `http://localhost:3001`

Run workshop assertions:

```bash
python3 -m pip install -r tests/requirements.txt
python3 tests/poc_exploits.py --base-url http://localhost:3000 --expect vulnerable --wait
python3 tests/poc_exploits.py --base-url http://localhost:3001 --expect secure --wait
```

Or with npm after dependencies are installed:

```bash
npm run workshop:test
```

Stop the lab:

```bash
docker compose down
```

## Local Node Mode

```bash
cd web-security/owasp-top-10
npm install
npm start
SECURE_MODE=true PORT=3001 npm start
```

## Scenarios

### 1. SQL Injection: OWASP A03

Vulnerable behavior:

```bash
curl "http://localhost:3000/api/users/search?username=' OR '1'='1"
```

Impact: direct string concatenation allows the attacker to alter SQL logic and retrieve the admin user.

Mitigation: secure mode uses parameterized queries.

### 2. Reflected XSS: OWASP A03

Vulnerable behavior:

```bash
curl "http://localhost:3000/api/welcome?name=<script>alert('XSS')</script>"
```

Impact: the vulnerable endpoint reflects user input into an HTML response.

Mitigation: secure mode uses JSON responses and Helmet security headers, so the payload is not rendered as executable HTML.

### 3. Missing Admin Authorization: OWASP A01

Vulnerable behavior:

```bash
curl http://localhost:3000/api/admin/config
```

Impact: administrative configuration is exposed without authorization.

Mitigation: secure mode checks the caller role. Anonymous callers receive `403`.

### 4. IDOR / Broken Object-Level Authorization: OWASP A01

Vulnerable behavior:

```bash
curl -H "x-user-id: 2" http://localhost:3000/api/profiles/101
```

Impact: a low-privilege user can access another user's profile by changing the object ID.

Mitigation: secure mode checks that `x-user-id` matches the profile owner.

## Expected Evidence

Capture redacted outputs in [evidence/README.md](./evidence/README.md):

- vulnerable mode PoC output,
- secure mode PoC output,
- representative HTTP status codes,
- notes about false positives or test limitations.

## Current Limitations

- The lab uses headers to model authenticated identity and role. That keeps the workshop small, but a production API would verify signed sessions or JWTs.
- Password hashing dependencies are present for future cryptographic-failures scenarios but not yet used by the active routes.
- OWASP ZAP baseline scanning is planned as the next upgrade.

## Best Practices Checklist

- [x] Use parameterized database queries.
- [x] Avoid rendering untrusted input as HTML.
- [x] Require authorization on admin endpoints.
- [x] Enforce object ownership checks.
- [ ] Add ZAP baseline scan.
- [ ] Add ASVS mapping per route.

