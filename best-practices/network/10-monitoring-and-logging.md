# 10. Monitoring and Logging: Near Real-time Visibility

You cannot protect what you cannot see. Monitoring is the final layer of your security architecture.

## 🛡️ Architect's Perspective
Implement **VPC Flow Logs** and **Firewall Rules Logging** to gain near real-time visibility into your Google Cloud network traffic and firewall activity. This is critical for detecting anomalies, auditing, and troubleshooting.

### 🚀 Key Monitoring Tools
1.  **VPC Flow Logs**: Captures every connection in the VPC (Source/Dest IP, Port, Duration).
2.  **Firewall Logging**: Captures allowed/denied traffic.
3.  **Firewall Insights**: Identifies unused or overly broad firewall rules.
4.  **Network Intelligence Center**: Centralized visibility into connectivity, topology, and security.

### ✅ Checklist for Network Monitoring
- [ ] Enable **VPC Flow Logs** on all production subnets.
- [ ] Enable **Firewall Rules Logging** for critical allow/deny rules.
- [ ] Monitor **Firewall Insights** and optimize rules regularly.
- [ ] Use **Cloud Logging and Monitoring** to create alerts for suspicious traffic patterns.

---
*Reference: [GCP Network Intelligence Center Overview](https://cloud.google.com/network-intelligence-center)*
