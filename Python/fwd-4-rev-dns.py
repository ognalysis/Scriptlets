import sys

# Record Example:
# example-111-222-333-0        IN      A       111.222.333.0

#str = "111.222.333."
str = sys.argv
subnet = str[1].split(".")

for ip in range(256):
	print("olp-", subnet[0], "-", subnet[1], "-", subnet[2], "-", ip, "\t\tIN\tA\t", subnet[0], ".", subnet[1], ".", subnet[2], ".", ip, sep='')
