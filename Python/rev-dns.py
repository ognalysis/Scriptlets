# Record Example:
# 0.40.43.8.in-addr.arpa. IN      PTR     olp-8-43-40-0.olp.net.

# Rev.conf Example:
# zone "333.222.111.in-addr-arpa" {
# 	type master;
# 	file "/etc/bind/rev/111.222.333.rev";
# 	};

# regex: ^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$

import re

userinput = ""

def validate_user_input(uput):

	uput = input("Enter an IPv4 Address: ")

	validate = re.search("^(?:(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])(\.(?!$)|$)){4}$", uput)

	if validate:
		print("VALID")
		print(uput)
		userinput = uput
	else:
		print("NOPE")
		validate_user_input(uput)

def print_rev_records_to_file(sub):
	print(type(sub))
#	filename = sub[0] + sub[1] + sub[2] + ".rev"
#	filename = sub[0] + ".rev"
#	print(filename)
#	f = open(

# MAIN ================================

# Take and Validate user input
validate_user_input(userinput)

#print(type(userinput))

#print(str(userinput))
# Split string
subnet = userinput.split(".")

#print(type(subnet))
#print(subnet[0])
#print(subnet[1])

print_rev_records_to_file(subnet)


# END MAIN ============================




#subnet = str.split(".")

#for ip in range(256):
#	print(ip, ".", subnet[2], ".", subnet[1], ".", subnet[0], "in-addr.arpa.\t\t IN\tPTR\tolp-", subnet[0], "-", subnet[1], "-", subnet[2], "-", ip, ".olp.net.", sep='')
