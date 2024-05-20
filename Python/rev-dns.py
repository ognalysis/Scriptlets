# Record Example:
# 0.40.43.8.in-addr.arpa. IN      PTR     example-8-43-40-0.example.com.

# Rev.conf Example:
# zone "333.222.111.in-addr-arpa" {
# 	type master;
# 	file "/etc/bind/rev/111.222.333.rev";
# 	};

# Rev Record file header example:
#$ttl 172800
#333.222.111.in-addr.arpa. IN      SOA     ns.example.com. root.example.com (
#                   2019120600
#                   10800
#                   3600
#                   432000
#                   38400 )
#333.222.111.in-addr.arpa.        IN      NS      ns.example.com.
#333.222.111.in-addr.arpa.        IN      NS      ns.example.com.

# regex: ^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$

from datetime import date
from time import sleep
import re, sys

today = date.today().strftime("%Y%m%d")

userinput = ""
filename = ""
sleepytime = 3

domain = "example.net"
print("Using Domain: " + domain)
sleep(sleepytime)

def validate_user_input(uput):

	uput = input("Enter an IPv4 Address: ")
	validate = re.search("^(?:(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(\.(?!$)|$)){4}$", uput)

	if validate:
		print("Valid IP!")
		#print(uput)
		return uput
	else:
		print("Not a valid IP; Try Again...")
		validate_user_input(uput)

def print_rev_records_to_file(sub):

#	print(type(sub))

	filename = sub[0] + "." + sub[1] + "."  + sub[2] + ".rev"
	print("Creating file...")
	sleep(sleepytime)
	f = open(filename, "x")

	rev_record_file_header(f, sub)

	for ip in range(256):
		f.write(str(ip) + "." + sub[2] + "." + sub[1] + "." + sub[0] + ".in-addr.arpa.\tIN\tPTR\t" + re.split("\.",domain,1)[0] + "-" + sub[0] + "." + sub[1] + "." + sub[2] + "." + str(ip) + "." + domain  + ".\r")

	f.close()
	print("Reverse Record File Finished!")
	sleep(sleepytime)

def rev_record_file_header(file, sn):
	file.write("$ttl 172800\r" + sn[2] + "." + sn[1] + "." + sn[0] + ".in-addr.arpa.\tIN\tSOA\tns." + domain + ". root." + domain + " (\r\t\t" + today + "00\r\t\t10800\r\t\t3600\r\t\t432000\r\t\t38400 )\r" + sn[2] + "." + sn[1] + "." + sn[0] + ".in-addr.arpa.\tIN\tNS\tns." + domain + ".\r" + sn[2] + "." + sn[1] + "." + sn[0] + ".in-addr.arpa.\tIN\tNS\tns2." + domain  + ".\r")

def rev_conf(sn):
	print("Creating Zone Configuration...")
	sleep(sleepytime)
	filename = sn[0] + "." + sn[1] + "." + sn[2] + ".conf"
	f = open(filename, "w")

	f.write("zone \"" + sn[2] + "." + sn[1] + "." + sn[0] + ".in-addr.arpa\" {\r\ttype master;\r\tfile \"/etc/bind/rev/" + sn[0] + "." + sn[1] + "." + sn[2] + ".rev\";\r\t};")
	f.close()
	print("Zone config done!")

# MAIN ================================

# Take and Validate user input
userinput = validate_user_input(userinput)

# Split string
subnet = userinput.split(".")

# Write Records to file
print_rev_records_to_file(subnet)

# Write record conf to file
rev_conf(subnet)

# END MAIN ============================
