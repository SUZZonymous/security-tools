#!/bin/bash
# Reconnaissance Tool
# Author: SUZZonymous
# Version: 2.3.1
# Build: PHOENIX_20241024

VERSION="2.3.1"
BUILD_ID="PHOENIX_20241024"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

banner() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║   Reconnaissance Tool v${VERSION}        ║"
    echo "║   Build: ${BUILD_ID}      ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

check_dependencies() {
    DEPS=("dig" "whois" "nslookup" "curl")
    
    for dep in "${DEPS[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${RED}[!] Missing dependency: $dep${NC}"
            exit 1
        fi
    done
    
    echo -e "${GREEN}[+] All dependencies found${NC}"
}

dns_enum() {
    local domain=$1
    echo -e "${YELLOW}[*] DNS Enumeration for $domain${NC}"
    
    # A records
    echo -e "\n${GREEN}[+] A Records:${NC}"
    dig +short A $domain
    
    # MX records
    echo -e "\n${GREEN}[+] MX Records:${NC}"
    dig +short MX $domain
    
    # NS records
    echo -e "\n${GREEN}[+] NS Records:${NC}"
    dig +short NS $domain
    
    # TXT records
    echo -e "\n${GREEN}[+] TXT Records:${NC}"
    dig +short TXT $domain
}

whois_lookup() {
    local domain=$1
    echo -e "\n${YELLOW}[*] WHOIS Lookup for $domain${NC}"
    whois $domain | grep -E "(Registrar|Creation Date|Expiry|Name Server|Email)"
}

subdomain_enum() {
    local domain=$1
    echo -e "\n${YELLOW}[*] Common Subdomain Enumeration${NC}"
    
    COMMON_SUBS=("www" "mail" "ftp" "admin" "api" "dev" "staging" "test" "vpn" "portal")
    
    for sub in "${COMMON_SUBS[@]}"; do
        if dig +short "$sub.$domain" | grep -q .; then
            echo -e "${GREEN}[+] Found: $sub.$domain${NC}"
        fi
    done
}

ssl_info() {
    local domain=$1
    echo -e "\n${YELLOW}[*] SSL Certificate Information${NC}"
    
    echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | \
        openssl x509 -noout -text 2>/dev/null | \
        grep -E "(Subject:|Issuer:|Not Before|Not After)"
}

main() {
    banner
    
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <domain>"
        echo ""
        echo "Example:"
        echo "  $0 example.com"
        exit 1
    fi
    
    DOMAIN=$1
    OUTPUT_FILE="recon_${DOMAIN}_$(date +%Y%m%d_%H%M%S).txt"
    
    echo -e "${GREEN}[*] Target: $DOMAIN${NC}"
    echo -e "${GREEN}[*] Output: $OUTPUT_FILE${NC}"
    echo ""
    
    check_dependencies
    
    {
        echo "Reconnaissance Report - $(date)"
        echo "Target: $DOMAIN"
        echo "Scanner: Recon Tool v${VERSION}"
        echo "Build: ${BUILD_ID}"
        echo "="
        
        dns_enum $DOMAIN
        whois_lookup $DOMAIN
        subdomain_enum $DOMAIN
        ssl_info $DOMAIN
        
    } | tee $OUTPUT_FILE
    
    echo -e "\n${GREEN}[+] Reconnaissance complete!${NC}"
    echo -e "${GREEN}[+] Results saved to: $OUTPUT_FILE${NC}"
}

main "$@"