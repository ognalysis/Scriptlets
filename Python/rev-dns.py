# Record Example:
# 0.40.43.8.in-addr.arpa. IN      PTR     olp-8-43-40-0.olp.net.

str = "38.187.145"
subnet = str.split(".")

for ip in range(256):
	print(ip, ".", subnet[2], ".", subnet[1], ".", subnet[0], "in-addr.arpa.\t\t IN\tPTR\tolp-", subnet[0], "-", subnet[1], "-", subnet[2], "-", ip, ".olp.net.", sep='')
