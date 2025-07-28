#!/bin/usr/env python

import sys
import csv
import subprocess
import re

def run_whois(ip):
    """Run whois command on an IP address."""
    try:
        result = subprocess.run(['whois', ip], capture_output=True, text=True)
        #print(f"=== WHOIS for {ip} ===")
        output = result.stdout
        #print(result.stdout.strip())
        match = re.search(r'^(OrgName|Organization)\s*:\s*(.+)$', output, re.MULTILINE | re.IGNORECASE)

        print(f"=== {ip} ===")
        if match:
            print(f"{match.group(1)}: {match.group(2)}")
        else:
            print("No OrgName/Organization found.")

#        if result.stderr:
#            print("Error:", result.stderr.strip())
        print("=" * 40 + "\n")
    except Exception as e:
        print(f"Error running whois on {ip}: {e}")


def process_csv(file_path):
    print(f"Opening: {file_path}")
    with open(file_path, newline='') as csvfile:
        print("debug: open csv")
        reader = csv.reader(csvfile)
        header = next(reader)  # assume first row is header
        ip_index = None

        # Try to find the column with the IP address
        for i, col_name in enumerate(header):
            if col_name.lower() in ['ip', 'ip_address', 'address']:
                ip_index = i
                break

        if ip_index is None:
            print("Could not find an IP address column in the header.")
            sys.exit(1)

        for row in reader:
            ip = row[ip_index].strip()
#            print(f"Found IP: {ip}")
            if ip:
                run_whois(ip)
#                print("debug")


if __name__ == "__main__":
#    print("script is running!")
    if len(sys.argv) != 2:
        print("Usage: python whois_lookup.py <file.csv>")
        sys.exit(1)

    csv_file_path = sys.argv[1]
    process_csv(csv_file_path)
