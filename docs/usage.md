# Usage Guide

## Scanner Tool
```bash
# Scan common ports
python3 tools/scanner.py 192.168.1.1

# Scan specific range
python3 tools/scanner.py example.com 1 10000

# Scan single port
python3 tools/scanner.py 10.0.0.1 80 80
```

## Reconnaissance Tool
```bash
# Full recon
./tools/recon.sh example.com

# Output is saved automatically
```

## Exfiltration Tester
```bash
# Test mode (safe)
python3 tools/exfil.py --test-mode

# Live mode (requires authorization)
python3 tools/exfil.py --live --data "SensitiveData"
```

## Build Information

All tools include build signature: `PHOENIX_20241024`
