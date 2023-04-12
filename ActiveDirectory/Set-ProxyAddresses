# Get Domain Creds
$creds = Get-Credential

# Get User object you're modifying
$user = Get-ADUser $(Read-Host "Enter Username") -Properties Name,ProxyAddresses; $user

# Clear the Existing ProxyAddresses
Set-ADUser $user -Clear ProxyAddresses -Credential $creds

# Set the ProxyAddress Format String
$proxyaddresses = "smtp:$($user.SamAccountName)@domain.com", "SMTP:$($user.SamAccountName)@domain2.com"
$proxyaddresses

# Add the ProxyAddresses string to the user object
foreach ($addr in $proxyaddresses){ Set-aduser -Identity $user -Add @{proxyaddresses = "$addr"} -Credential $creds };

# See the new updated data
Get-ADUser $user.SamAccountName -Properties proxyaddresses | select-Object Name,@{n="ProxyAddresses";e= { $_.ProxyAddresses -join ";"}}
