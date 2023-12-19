import sys, re
from datetime import datetime

#base pattern to return IPs
#pattern = re.compile(r"lease\s+([0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?)\s+\{\s+starts\s+[0-9]\s+(.*);\s+ends\s+[0-9]\s+(.*)")

def find_IP(OCT1,OCT2,OCT3):
	pattern = re.compile(r"lease\s+("+re.escape(OCT1)+"\."+re.escape(OCT2)+"\."+re.escape(OCT3)+"\.[0-9][0-9]?[0-9]?)\s+\{\s+starts\s+[0-9]\s+(.*);\s+ends\s+[0-9]\s+(.*);")

	with open("/home/kogint/dhcpd.leases") as f:
		for match in pattern.finditer(f.read()):
			if datetime.strptime(match.group(3), '%Y/%m/%d %H:%M:%S') < datetime.now():
				pass
			else:
				print('IP: ' + match.group(1) + "\n" + 'Starts: ' +  match.group(2) + "\n" + 'Ends: ' +  match.group(3) + "\n")
				#print('IP: ' + match.group(1) + " - " + 'Starts: ' +  match.group(2) + " - " + 'Ends: ' +  match.group(3))

#################################################

#67.217.144.0/20
OCT1 = "67"
OCT2 = "217"
for oct in range(144,160):
	find_IP(OCT1, OCT2, str(oct))

#216.14.144.0/20
OCT1 = "216"
OCT2 = "14"
for oct in range (144,160):
	find_IP(OCT1, OCT2, str(oct))

#162.208.44.0/22
OCT1 = "162"
OCT2 = "208"
for oct in range (44,48):
        find_IP(OCT1, OCT2, str(oct))

#8.43.40.0/23
OCT1 = "8"
OCT2 = "43"
for oct in range (40,42):
        find_IP(OCT1, OCT2, str(oct))

#209.150.240.0/20
OCT1 = "209"
OCT2 = "150"
for oct in range (240,256):
        find_IP(OCT1, OCT2, str(oct))

#38.59.144/20
OCT1 = "38"
OCT2 = "59"
for oct in range (144,160):
        find_IP(OCT1, OCT2, str(oct))
