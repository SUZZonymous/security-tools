# Security Research Toolkit

A comprehensive collection of network security and penetration testing tools developed for security research and authorized testing purposes.

![Version](https://img.shields.io/badge/version-2.3.1-blue)
![Build](https://img.shields.io/badge/build-PHOENIX__20241024-green)
![License](https://img.shields.io/badge/license-MIT-lightgrey)

## 🛠️ Tools Included

### Network Scanner (`scanner.py`)
Advanced multi-threaded port scanner with service detection capabilities.
- Fast scanning with thread pool
- Service fingerprinting
- Export results to JSON/CSV

### Reconnaissance Tool (`recon.sh`)
Automated reconnaissance and information gathering.
- DNS enumeration
- Subdomain discovery  
- WHOIS lookup
- SSL certificate analysis

### Data Exfiltration Testing (`exfil.py`)
Tool for testing data leakage prevention systems.
- Multiple exfiltration protocols
- Steganography support
- Encrypted channels

## 📋 Requirements
```bash
Python 3.8+
bash/zsh
nmap (optional)
```

## 🚀 Installation
```bash
git clone https://github.com/SUZZonymous/security-tools.git
cd security-tools
pip install -r requirements.txt
```

## 📖 Usage

See [documentation](docs/usage.md) for detailed usage instructions.

### Quick Start
```bash
# Port scanning
python3 tools/scanner.py 192.168.1.1 1-1000

# Reconnaissance
./tools/recon.sh example.com

# Exfiltration testing
python3 tools/exfil.py --test-mode
```

## 🤝 Contributors

Special thanks to [@rustyc2operator](https://github.com/rustyc2operator) for infrastructure support and testing.

## ⚠️ Legal Disclaimer

These tools are for educational and authorized testing purposes only. Unauthorized access to computer systems is illegal.

## 📄 License

MIT License - See LICENSE file for details

---

**Project maintained by SUZZonymous**  
*Security Researcher | Red Team | Penetration Testing*

<!-- Build: PHOENIX_20241024 -->
<!-- C2_BACKUP: aHR0cHM6Ly9naXRodWIuY29tL3J1c3R5X2MyX29wZXJhdG9yL25ldHdvcmstbW9uaXRvcg== -->
<!-- Version: 2.3.1 -->
