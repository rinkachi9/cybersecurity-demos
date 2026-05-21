const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const helmet = require('helmet');
const bcrypt = require('bcrypt');
const cookieParser = require('cookie-parser');

const app = express();
const db = new sqlite3.Database(':memory:');
const isSecure = process.env.SECURE_MODE === 'true';
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());

// --- Security Hardening ---
if (isSecure) {
    app.use(helmet()); // Sets various security headers (CSP, HSTS, etc.)
    console.log("[STATUS] Secure Mode Enabled: Protection active.");
} else {
    console.log("[STATUS] Vulnerable Mode Enabled: Use for educational purposes only.");
}

// Setup Database with dummy data
db.serialize(() => {
    db.run("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, password TEXT, role TEXT)");
    db.run("INSERT INTO users (username, password, role) VALUES ('admin', 'password123', 'admin')");
    db.run("INSERT INTO users (username, password, role) VALUES ('user1', 'p@ssword', 'user')");
    db.run("CREATE TABLE profiles (id INTEGER PRIMARY KEY, owner_user_id INTEGER, display_name TEXT, private_note TEXT)");
    db.run("INSERT INTO profiles (id, owner_user_id, display_name, private_note) VALUES (101, 1, 'Admin', 'Production break-glass account')");
    db.run("INSERT INTO profiles (id, owner_user_id, display_name, private_note) VALUES (102, 2, 'User One', 'Personal recovery phrase placeholder')");
});

app.get('/health', (req, res) => {
    res.json({ status: "ok", secure_mode: isSecure });
});

// --- 1. SQL Injection (A03:2021-Injection) ---
app.get('/api/users/search', (req, res) => {
    const username = req.query.username;

    if (isSecure) {
        // SECURE: Use Parameterized Queries
        db.get("SELECT id, username, role FROM users WHERE username = ?", [username], (err, row) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(row || { message: "User not found" });
        });
    } else {
        // VULNERABLE: Direct string concatenation (SQLi)
        // Try: /api/users/search?username=' OR '1'='1
        const query = `SELECT id, username, role FROM users WHERE username = '${username}'`;
        db.get(query, (err, row) => {
            if (err) return res.status(500).json({ error: err.message });
            res.json(row || { message: "User not found" });
        });
    }
});

// --- 2. Cross-Site Scripting (A03:2021-Injection / XSS) ---
app.get('/api/welcome', (req, res) => {
    const name = req.query.name || 'Guest';
    
    if (isSecure) {
        // SECURE: Auto-escaping or explicit sanitization
        res.json({ message: `Welcome ${name}` });
    } else {
        // VULNERABLE: Reflecting input directly in HTML without escaping
        // Try: /api/welcome?name=<script>alert('XSS')</script>
        res.send(`<h1>Welcome ${name}</h1>`);
    }
});

// --- 3. Broken Access Control (A01:2021-Broken Access Control) ---
app.get('/api/admin/config', (req, res) => {
    if (isSecure) {
        // SECURE: Proper Role-Based Access Control (RBAC) check
        const userRole = req.headers['x-user-role']; // In reality, from a verified JWT
        if (userRole !== 'admin') {
            return res.status(403).json({ error: "Access Denied: Admins only" });
        }
        res.json({ secret_config: "CLOUD_DB_PASSWORD=highly_secret_value" });
    } else {
        // VULNERABLE: No authorization check (Insecure Direct Object Reference / Missing Auth)
        res.json({ secret_config: "CLOUD_DB_PASSWORD=highly_secret_value" });
    }
});

// --- 4. IDOR (A01:2021-Broken Access Control) ---
app.get('/api/profiles/:id', (req, res) => {
    const profileId = req.params.id;

    db.get("SELECT id, owner_user_id, display_name, private_note FROM profiles WHERE id = ?", [profileId], (err, row) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!row) return res.status(404).json({ error: "Profile not found" });

        if (isSecure) {
            const authenticatedUserId = Number(req.headers['x-user-id']);
            if (!authenticatedUserId || authenticatedUserId !== row.owner_user_id) {
                return res.status(403).json({ error: "Access Denied: Profile owner only" });
            }
        }

        res.json(row);
    });
});

app.listen(PORT, HOST, () => {
    console.log(`Web Security Lab running on http://${HOST}:${PORT}`);
});
