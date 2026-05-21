# Evidence: OWASP Top 10 Lab

This folder captures safe, redacted evidence for the web security lab.

## Expected Evidence

- Output from `python3 tests/poc_exploits.py --expect vulnerable` against vulnerable mode.
- Output from `python3 tests/poc_exploits.py --expect secure` against secure mode.
- HTTP response samples proving SQLi, XSS, missing admin authorization, and IDOR behavior.
- Docker Compose health status for both services.
- Future ZAP baseline output after the lab gets containerized.

## Do Not Commit

- Real session cookies.
- Production URLs.
- Real user data.
- Full browser profiles or local database dumps.
