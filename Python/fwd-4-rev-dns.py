# Record Example:
# olp-216-14-144-0        IN      A       216.14.144.0

str = "38.187.145"
subnet = str.split(".")

for ip in range(256):
	print("olp-", subnet[0], "-", subnet[1], "-", subnet[2], "-", ip, "\t\tIN\tA\t", subnet[0], ".", subnet[1], ".", subnet[2], ".", ip, sep='')
