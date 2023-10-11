# Connect to Active Directory
Import-Module ActiveDirectory

# Get all users with no manager
$users = Get-ADUser -LDAPFilter "(!manager=*)" -Properties Manager

# Display the results
foreach ($user in $users) {
    Write-Host "User: $($user.Name)"
}
