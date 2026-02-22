# 07. Network Analysis: IDS and Packet Mirroring

Analyzing network traffic is critical for advanced threat detection and forensics. Don't rely on just logs.

## 🛡️ Architect's Perspective
Google Cloud provides two complementary tools for network analysis: **Cloud IDS** and **Packet Mirroring**. **Cloud IDS** provides managed visibility into VPC traffic with Palo Alto-powered signatures. **Packet Mirroring** allows you to clone and forward traffic for deep inspection with your own security tools.

### 🚀 Comparison
1.  **Cloud IDS**: A managed Intrusion Detection System that detects malware, C2, and lateral movement with zero maintenance.
2.  **Packet Mirroring**: A powerful way to feed traffic into custom NDR (Network Detection and Response) tools like Suricata, Zeek, or Wireshark.

### ✅ Checklist for Network Analysis
- [ ] Implement **Cloud IDS** for managed intrusion detection on critical subnets.
- [ ] Use **Packet Mirroring** for deep packet inspection and forensic analysis.
- [ ] Monitor IDS findings in the **Security Command Center (SCC)**.
- [ ] Filter mirrored traffic by protocol (TCP/UDP/ICMP) to optimize collector performance.

---
*Reference: [GCP Cloud IDS Overview](https://cloud.google.com/cloud-ids/docs)*
