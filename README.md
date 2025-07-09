# ICMP Timestamp Disclosure POC (CVE-1999-0524)

<a href="https://ibb.co/jvVtppFM"><img src="https://i.ibb.co/ccbqmmdF/icmp-poc1.png" alt="icmp-poc1" border="0"></a>

This Proof-of-Concept script demonstrates the **CVE-1999-0524** vulnerability, which allows remote attackers to obtain a target system's current date and time via **ICMP timestamp responses**.

---

## 🛡️ Vulnerability Information

- **CVE ID:** CVE-1999-0524  
- **Severity:** Low (Information Disclosure)  
- **Affected Systems:** Any system that responds to ICMP timestamp requests (Type 13)  
- **Impact:** Remote disclosure of system time  

---

## ✨ Features

- Automatically retrieves ICMP timestamps using either `nping` or `hping3`
- Manual mode for analyzing captured timestamps
- Converts timestamps to human-readable time format
- Vulnerability assessment with color-coded output
- Supports custom UTC dates for analysis
- Banner suppression option for scripting

---

## ⚙️ Requirements

- Linux-based operating system
- `nping` (from the Nmap package) or `hping3`
- Sudo privileges (for sending ICMP requests)
- Bash 4.0+

---

## 📦 Installation

### Install Required Tools

```bash
sudo apt update
sudo apt install nmap hping3
