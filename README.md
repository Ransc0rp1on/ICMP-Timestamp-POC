ICMP Timestamp Disclosure POC (CVE-1999-0524)
https://img.shields.io/badge/CVE-1999--0524-Remote_Date_Disclosure-red
https://img.shields.io/badge/License-MIT-blue

This Proof-of-Concept script demonstrates the CVE-1999-0524 vulnerability, which allows remote attackers to obtain a target system's current date and time via ICMP timestamp responses.

Vulnerability Information
CVE ID: CVE-1999-0524
Severity: Low (Information Disclosure)
Affected Systems: Any system that responds to ICMP timestamp requests (type 13)
Impact: Remote disclosure of system time

Features
Automatically retrieves ICMP timestamps using either nping or hping3

Manual mode for analyzing captured timestamps

Converts timestamps to human-readable time format

Vulnerability assessment with color-coded output

Supports custom UTC dates for analysis

Banner suppression option for scripting

Requirements
Linux-based operating system

nping (from Nmap package) or hping3

Sudo privileges (for sending ICMP requests)

Bash 4.0+

Installation
Install required tools:

bash
sudo apt update
sudo apt install nmap hping3
Clone the repository:

bash
git clone https://github.com/yourusername/ICMP-Timestamp-POC.git
cd ICMP-Timestamp-POC
Make the script executable:

bash
chmod +x icmp_timestamp.sh
Usage
Basic Automatic Mode
bash
sudo ./icmp_timestamp.sh -i <TARGET_IP>
Specify Tool (nping or hping3)
bash
sudo ./icmp_timestamp.sh -i <TARGET_IP> -t hping3
Manual Mode (with captured timestamps)
bash
./icmp_timestamp.sh -O <ORIGINATE> -R <RECEIVE> -T <TRANSMIT>
Suppress Banner
bash
sudo ./icmp_timestamp.sh -i <TARGET_IP> -s
Custom UTC Date
bash
sudo ./icmp_timestamp.sh -i <TARGET_IP> -u "2025-07-09"
Examples
Vulnerable Host
bash
sudo ./icmp_timestamp.sh -i 192.168.1.100
Output:

text
#################################################
#     CVE-1999-0524 - Remote Date Disclosure    #
#          Created By ransc0rp1on               #
#################################################

=== Timestamp Analysis Results ===
Parsed ICMP Timestamps:
  Originate: 0
  Receive:   27662289
  Transmit:  27662289

Remote System Time:
  Milliseconds since midnight UTC: 27662289
  Human-readable time:             07:41:02.289
  Full UTC datetime:               2025-07-09T07:41:02.289Z

=== Vulnerability Assessment ===
[!] Host is VULNERABLE to CVE-1999-0524
The target is disclosing its system time via ICMP timestamps
Disclosed remote time: 2025-07-09T07:41:02.289Z
Non-Vulnerable Host
bash
sudo ./icmp_timestamp.sh -i 192.168.1.200
Output:

text
#################################################
#     CVE-1999-0524 - Remote Date Disclosure    #
#          Created By ransc0rp1on               #
#################################################

[!] Host not vulnerable to CVE-1999-0524
The target is not disclosing its system time via ICMP timestamps
Output Interpretation
Vulnerable Host:

Shows parsed timestamps

Calculates and displays the remote system time

Clearly indicates the vulnerability status with green highlight

Non-Vulnerable Host:

Shows a blue notification that the host is not vulnerable

Indicates the target doesn't disclose its system time

Mitigation
To protect systems against this information disclosure vulnerability:

Disable ICMP timestamp responses:

bash
sysctl -w net.ipv4.icmp_echo_ignore_all=1
Configure firewall to block ICMP timestamp requests:

bash
iptables -A INPUT -p icmp --icmp-type timestamp-request -j DROP
For persistent configuration, add to /etc/sysctl.conf:

text
net.ipv4.icmp_echo_ignore_all=1
License
This project is licensed under the MIT License - see the LICENSE file for details.

Disclaimer
This tool is for educational and security testing purposes only. Use this tool only on systems you own or have explicit permission to test. The author is not responsible for any misuse or damage caused by this tool.

Contribution
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
