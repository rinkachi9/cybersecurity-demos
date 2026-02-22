# Lab: OWASP Top 10 Mitigation

This module demonstrates common web application vulnerabilities and their mitigation in a Node.js/Express environment.

## 🚀 How to Run

1. Navigate to the directory: `cd web-security/owasp-top-10`
2. Install dependencies: `npm install`
3. Start in Vulnerable mode: `npm start`
4. Start in Secure mode: `npm run start:secure`

---

## 🛡️ Analyzed Vulnerabilities

### 1. SQL Injection (A03:2021)
*   **Vulnerability**: The application builds SQL queries by directly concatenating strings with user-provided data.
*   **Exploit (PoC)**:
    `curl "http://localhost:3000/api/users/search?username=' OR '1'='1"`
    Will return the first user from the database (admin), even without knowing the login.
*   **Fix**: Use **Parameterized Queries** (Prepared Statements). Data is treated as a literal, not as executable code.

### 2. Cross-Site Scripting (XSS) (A03:2021)
*   **Vulnerability**: The application reflects user input directly into the HTML without prior filtering or encoding.
*   **Exploit (PoC)**:
    Open in your browser: `http://localhost:3000/api/welcome?name=<script>alert('XSS')</script>`
*   **Fix**: 
    - Output encoding (Context-aware output encoding).
    - Use **Content-Security-Policy (CSP)** (provided by the `helmet` module).
    - Prefer JSON responses instead of raw HTML.

### 3. Broken Access Control (A01:2021)
*   **Vulnerability**: The administrative endpoint `/api/admin/config` is accessible to anyone who knows its URL (Security through obscurity).
*   **Exploit (PoC)**:
    `curl http://localhost:3000/api/admin/config`
    Provides access to configuration secrets without any authorization.
*   **Fix**: Implement **RBAC (Role-Based Access Control)**. Every protected resource must verify user permissions (e.g., based on a verified JWT).

---

## 🛠️ Best Practices (Checklist)
- [ ] Always use `helmet()` in Express applications.
- [ ] Never trust user input (`req.query`, `req.body`, `req.params`).
- [ ] Apply the **Least Privilege** principle for the technical account connecting to the database.
- [ ] Regularly scan dependencies using `npm audit` or `snyk`.
