#!/bin/bash

# Function to print the CVE banner
print_banner() {
  echo "#################################################"
  echo "#     CVE-1999-0524 - Remote Date Disclosure    #"
  echo "#          Created By ransc0rp1on               #"
  echo "#################################################"
}

# Initialize variables
suppress_banner=0
originate=""
receive=""
transmit=""
today_date=""
target_ip=""
tool="nping"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to show usage instructions
usage() {
  echo "Usage: $0 [-i <IP> [-t nping|hping3]] | -O <Originate> -R <Receive> -T <Transmit>"
  echo "Options:"
  echo "  -i <IP>          Target IP address for automatic timestamp retrieval"
  echo "  -t <tool>        Tool to use for automatic mode (nping or hping3, default: nping)"
  echo "  -O <Originate>   Originate timestamp (manual mode)"
  echo "  -R <Receive>     Receive timestamp (manual mode)"
  echo "  -T <Transmit>    Transmit timestamp (manual mode)"
  echo "  -u <UTC date>    Custom UTC date (format: YYYY-MM-DD)"
  echo "  -s               Suppress banner"
  echo "  -h               Show this help"
  exit 1
}

# Parse command line options
while getopts "O:R:T:u:hs:i:t:" opt; do
  case ${opt} in
    O) originate=$OPTARG ;;
    R) receive=$OPTARG ;;
    T) transmit=$OPTARG ;;
    u) today_date=$OPTARG ;;
    h) usage ;;
    s) suppress_banner=1 ;;
    i) target_ip=$OPTARG ;;
    t) tool=$OPTARG ;;
    *) usage ;;
  esac
done

# Check for mode conflicts
if [ -n "$target_ip" ] && { [ -n "$originate" ] || [ -n "$receive" ] || [ -n "$transmit" ]; }; then
  echo "Error: Cannot combine automatic mode (-i) with manual timestamp options (-O, -R, -T)"
  usage
fi

# Check required arguments
if [ -z "$target_ip" ] && { [ -z "$originate" ] || [ -z "$receive" ] || [ -z "$transmit" ]; }; then
  echo "Error: Either provide an IP for automatic mode (-i) or all timestamps (-O, -R, -T)"
  usage
fi

# Show banner if not suppressed
if [ $suppress_banner -eq 0 ]; then
  print_banner
fi

# Convert milliseconds to human-readable time
timestamp_to_human_readable() {
  local ms=$1
  local hours=$((ms / 3600000))
  local minutes=$(((ms % 3600000) / 60000))
  local seconds=$(((ms % 60000) / 1000))
  local milliseconds=$((ms % 1000))
  printf "%02d:%02d:%02d.%03d" $hours $minutes $seconds $milliseconds
}

# Automatic mode processing
if [ -n "$target_ip" ]; then
  # Validate tool choice
  tool=${tool:-nping}
  if [[ "$tool" != "nping" && "$tool" != "hping3" ]]; then
    echo -e "${RED}Error: Invalid tool specified. Use nping or hping3.${NC}"
    exit 1
  fi

  # Check if tool is installed
  if ! command -v $tool &>/dev/null; then
    echo -e "${RED}Error: $tool is not installed.${NC}"
    exit 1
  fi

  # Run appropriate command
  if [ "$tool" == "nping" ]; then
    output=$(sudo nping --icmp --icmp-type 13 "$target_ip" 2>&1)
    retval=$?
  elif [ "$tool" == "hping3" ]; then
    output=$(sudo hping3 --icmp --icmptype 13 -c 1 "$target_ip" 2>&1)
    retval=$?
  fi

  # Check command success
  if [ $retval -ne 0 ]; then
    echo -e "${RED}Error: $tool command failed with exit code $retval${NC}"
    echo "Command output:"
    echo "$output"
    exit 1
  fi

  # Parse output
  if [ "$tool" == "nping" ]; then
    # Get first reply line only
    reply_line=$(echo "$output" | grep -m1 'Timestamp reply')
    originate=$(echo "$reply_line" | sed -n 's/.* orig=\([0-9]\+\).*/\1/p')
    receive=$(echo "$reply_line" | sed -n 's/.* recv=\([0-9]\+\).*/\1/p')
    transmit=$(echo "$reply_line" | sed -n 's/.* trans=\([0-9]\+\).*/\1/p')
  elif [ "$tool" == "hping3" ]; then
    reply_line=$(echo "$output" | grep -m1 'ICMP Timestamp Reply')
    originate=$(echo "$reply_line" | sed -n 's/.*Originate=\([0-9]\+\).*/\1/p')
    receive=$(echo "$reply_line" | sed -n 's/.*Receive=\([0-9]\+\).*/\1/p')
    transmit=$(echo "$reply_line" | sed -n 's/.*Transmit=\([0-9]\+\).*/\1/p')
  fi

  # Validate parsed values
  if ! [[ "$originate" =~ ^[0-9]+$ ]] || ! [[ "$receive" =~ ^[0-9]+$ ]] || ! [[ "$transmit" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Error: Failed to parse timestamps from $tool output${NC}"
    echo "Searched in line: '$reply_line'"
    echo "Full command output:"
    echo "$output"
    exit 1
  fi
fi

# Get current UTC date if not provided
today_date=${today_date:-$(date -u +"%Y-%m-%d")}

# Check if all timestamps are zero (host not vulnerable)
if [[ "$originate" == "0" && "$receive" == "0" && "$transmit" == "0" ]]; then
  echo -e "\n[${BLUE}!${NC}] ${BLUE}Host not vulnerable to CVE-1999-0524${NC}"
  echo -e "The target is not disclosing its system time via ICMP timestamps"
  exit 0
fi

# Calculate remote system time (average of receive and transmit)
remote_system_time=$(( (receive + transmit) / 2 ))
remote_time_human=$(timestamp_to_human_readable $remote_system_time)
remote_datetime_utc="${today_date}T${remote_time_human}Z"

# Output results
echo -e "\n${YELLOW}=== Timestamp Analysis Results ===${NC}"
cat <<EOF
Parsed ICMP Timestamps:
  Originate: $originate
  Receive:   $receive
  Transmit:  $transmit

Remote System Time:
  Milliseconds since midnight UTC: $remote_system_time
  Human-readable time:             $remote_time_human
  Full UTC datetime:               $remote_datetime_utc
EOF

# Vulnerability conclusion
echo -e "\n${YELLOW}=== Vulnerability Assessment ===${NC}"
echo -e "[${GREEN}!${NC}] ${GREEN}Host is VULNERABLE to CVE-1999-0524${NC}"
echo -e "The target is disclosing its system time via ICMP timestamps"
echo -e "Disclosed remote time: ${GREEN}$remote_datetime_utc${NC}"
