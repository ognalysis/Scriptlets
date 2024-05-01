# Record Example:
# 0.40.43.8.in-addr.arpa. IN      PTR     olp-8-43-40-0.olp.net.

# Rev.conf Example:
# zone "333.222.111.in-addr-arpa" {
# 	type master;
# 	file "/etc/bind/rev/111.222.333.rev";
# 	};

# Rev Record file header example:
#$ttl 172800
#151.217.67.in-addr.arpa. IN      SOA     ns.example.com. root.example.com (
#                   2019120600
#                   10800
#                   3600
#                   432000
#                   38400 )
#333.222.111.in-addr.arpa.        IN      NS      ns.example.com.
#333.222.111.in-addr.arpa.        IN      NS      ns.example.com.

# regex: ^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$

from datetime import date
import re, sys

today = date.today().strftime("%Y%m%d")

userinput = ""
filename = ""

domain = "example.net"

def validate_user_input(uput):

	uput = input("Enter an IPv4 Address: ")
	validate = re.search("^(?:(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(\.(?!$)|$)){4}$", uput)

	if validate:
		print("VALID")
		print(uput)
		return uput
	else:
		print("NOPE")
		validate_user_input(uput)

def print_rev_records_to_file(sub):

	print(type(sub))

	filename = sub[0] + "." + sub[1] + "."  + sub[2] + ".rev"
	print(filename)
	f = open(filename, "x")

	rev_record_file_header(f, sub)

	for ip in range(256):
# 		This is forward record, not reverse...
#		f.write("olp-" + sub[0] + "-" + sub[1] + "-" + sub[2] + "-" + str(ip) + "\t\tIN\tA\t" + sub[0] + "." + sub[1] + "." + sub[2] + "." + str(ip) + "\n")

		f.write(str(ip) + "." + sub[2] + "." + sub[1] + "." + sub[0] + ".in-addr.arpa.\tIN\tPTR\t" + re.split("\.",domain,1)[0] + "-" + sub[0] + "." + sub[1] + "." + sub[2] + "." + str(ip) + "." + domain  + ".\n")

	f.close()

#def check_file_exists(filename):
#	if(filename)
#		return false
#	else
#		return true

#def create_record_file(sub):
	#if(check_file_exists(filename)
#		print("file exists")
#		break

#	filename = sub[0] + "." + sub[1] + "."  + sub[2] + ".rev"
#	print(filename)
#	f = open(filename, "x")
#	f.close()

def rev_record_file_header(file, sn):
	file.write("$ttl 172800\n" + sn[2] + "." + sn[1] + "." + sn[0] + ".in-addr.arpa.\tIN\tSOA\tns." + domain + " root." + domain + " (\n\t\t" + today + "00\n\t\t10800\n\t\t3600\n\t\t432000\n\t\t38400 )\n151.217.67.in-addr.arpa.\tIN\tNS\tns." + domain + ".\n151.217.67.in-addr.arpa.\tIN\tNS\tns2." + domain  + ".\n")

# MAIN ================================

# Take and Validate user input
userinput = validate_user_input(userinput)

# Split string
subnet = userinput.split(".")

# Write Records to file
print_rev_records_to_file(subnet)


# END MAIN ============================




#subnet = str.split(".")

#for ip in range(256):
#	print(ip, ".", subnet[2], ".", subnet[1], ".", subnet[0], "in-addr.arpa.\t\t IN\tPTR\tolp-", subnet[0], "-", subnet[1], "-", subnet[2], "-", ip, ".olp.net.", sep='')
