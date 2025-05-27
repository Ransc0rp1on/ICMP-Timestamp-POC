# ICMP Timestamp Disclosure Analyzer (CVE-1999-0524)

Detect and analyze ICMP timestamp responses to identify systems vulnerable to CVE-1999-0524. Automatically retrieves and converts timestamps into human-readable UTC times using `nping` or `hping3`.

![Banner](https://via.placeholder.com/800x200.png?text=CVE-1999-0524+ICMP+Timestamp+Disclosure+Analyzer)

## Features
- **Automatic Mode**: Fetch timestamps directly from target IPs using `nping` or `hping3`
- **Manual Mode**: Process pre-captured timestamps (`-O`, `-R`, `-T`)
- **Time Conversion**: Milliseconds → UTC datetime (e.g., `12:34:56.789Z`)
- **Vulnerability Check**: Instant identification of non-vulnerable hosts
- **Tool Agnostic**: Supports both `nping` and `hping3` for flexibility

## Installation
```bash
git clone https://github.com/yourusername/icmp-timestamp-analyzer.git
cd icmp-timestamp-analyzer
chmod +x analyze_icmp_timestamps.sh
