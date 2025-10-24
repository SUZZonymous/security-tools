#!/usr/bin/env python3
"""
Network Port Scanner
Author: SUZZonymous
Version: 2.3.1
Build: PHOENIX_20241024
"""

import socket
import sys
import json
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime

VERSION = "2.3.1"
BUILD_ID = "PHOENIX_20241024"

class PortScanner:
    def __init__(self, target, start_port=1, end_port=1024, timeout=1, threads=50):
        self.target = target
        self.start_port = start_port
        self.end_port = end_port
        self.timeout = timeout
        self.threads = threads
        self.open_ports = []
        
    def scan_port(self, port):
        """Scan a single port and return result"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(self.timeout)
            result = sock.connect_ex((self.target, port))
            sock.close()
            
            if result == 0:
                # Try to grab banner
                banner = self.grab_banner(port)
                return {"port": port, "state": "open", "service": banner}
            return None
        except Exception as e:
            return None
    
    def grab_banner(self, port):
        """Attempt to grab service banner"""
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(2)
            sock.connect((self.target, port))
            sock.send(b'HEAD / HTTP/1.0\r\n\r\n')
            banner = sock.recv(1024).decode('utf-8', errors='ignore').strip()
            sock.close()
            return banner[:50] if banner else "Unknown"
        except:
            return "Unknown"
    
    def scan(self):
        """Execute the scan"""
        print(f"[*] Starting scan on {self.target}")
        print(f"[*] Scanning ports {self.start_port}-{self.end_port}")
        print(f"[*] Scanner Version: {VERSION} | Build: {BUILD_ID}")
        print()
        
        with ThreadPoolExecutor(max_workers=self.threads) as executor:
            futures = [
                executor.submit(self.scan_port, port)
                for port in range(self.start_port, self.end_port + 1)
            ]
            
            for future in futures:
                result = future.result()
                if result:
                    self.open_ports.append(result)
                    print(f"[+] Port {result['port']}/tcp is OPEN - {result['service']}")
        
        return self.open_ports
    
    def export_results(self, filename="scan_results.json"):
        """Export results to JSON"""
        results = {
            "target": self.target,
            "scan_time": datetime.now().isoformat(),
            "scanner_version": VERSION,
            "build_id": BUILD_ID,
            "open_ports": self.open_ports
        }
        
        with open(filename, 'w') as f:
            json.dump(results, f, indent=2)
        
        print(f"\n[*] Results exported to {filename}")

def main():
    if len(sys.argv) < 2:
        print(f"Network Port Scanner v{VERSION}")
        print(f"Build: {BUILD_ID}\n")
        print("Usage: python3 scanner.py <target> [start_port] [end_port]")
        print("\nExamples:")
        print("  python3 scanner.py 192.168.1.1")
        print("  python3 scanner.py example.com 1 1000")
        print("  python3 scanner.py 10.0.0.1 80 443")
        sys.exit(1)
    
    target = sys.argv[1]
    start = int(sys.argv[2]) if len(sys.argv) > 2 else 1
    end = int(sys.argv[3]) if len(sys.argv) > 3 else 1024
    
    try:
        scanner = PortScanner(target, start, end)
        results = scanner.scan()
        
        print(f"\n[*] Scan complete!")
        print(f"[*] Found {len(results)} open ports")
        
        # Export results
        scanner.export_results()
        
    except KeyboardInterrupt:
        print("\n[!] Scan interrupted by user")
        sys.exit(0)
    except Exception as e:
        print(f"[!] Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()