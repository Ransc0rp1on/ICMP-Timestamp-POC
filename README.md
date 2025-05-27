# ICMP Timestamp Disclosure Analyzer (CVE-1999-0524)

Detect and analyze ICMP timestamp responses to identify systems vulnerable to CVE-1999-0524. Automatically retrieves and converts timestamps into human-readable UTC times using `nping` or `hping3`.

<a href="https://ibb.co/F4vrHsQN">
  <img src="https://i.ibb.co/hF56YXGh/icmp-POC-1.png" alt="icmp-POC-1" width="900" border="0" height="150">
</a>

<a href="https://ibb.co/C3xW3qz4"><img src="https://i.ibb.co/ksYMspxz/icmp-POC-2.png" alt="icmp-POC-2" border="0"></a>
## Features
- **Automatic Mode**: Fetch timestamps directly from target IPs using `nping` or `hping3`
- **Manual Mode**: Process pre-captured timestamps (`-O`, `-R`, `-T`)
- **Time Conversion**: Milliseconds → UTC datetime (e.g., `12:34:56.789Z`)
- **Vulnerability Check**: Instant identification of non-vulnerable hosts
- **Tool Agnostic**: Supports both `nping` and `hping3` for flexibility

