#Credit for Regex goes to Ifedi Okonkwo
# https://stackoverflow.com/a/55846591
function IsValidEmail { 
    param([string]$Email)
    $Regex = '^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'

   try {
        $obj = [mailaddress]$Email
        if($obj.Address -match $Regex){
            return $True
        }
        return $False
    }
    catch {
        return $False
    } 
}

$Email = Read-Host "Enter Email"
while (!(IsValidEmail -Email $Email)){Write-Host "Invalid Email..."; $Email = Read-Host "Enter Email"}
if (!(IsValidEmail -Email $Email)) {write-host "Invalid email. Quitting."; exit 23;}
else {
    Write-Host "Connecting to Azure..."; Connect-AzureAD
    Write-Host "Please provide On-prem AD Credentials..."; $Creds = Get-Credential
    
    $AzureADUser = Get-AzureADUser -ObjectID $Email
    if ($AzureADUser.AccountEnabled) {Write-Host "Disabling Azure User..."; Set-AzureADUser -AccountEnabled $False; Write-Host "Azure User Disabled"}
    else {Write-host "Azure User is already disabled."}

    $ADUser = Get-ADUser -Filter "EmailAddress -eq '$Email'"
    $Status = $ADUser | fl -Property Enabled | out-string
    if ($Status.ToLower() -match "enabled : true"){Write-Host "Disabling AD User..."; Disable-ADAccount -Identity -Credential $Creds}
    else {Write-Host "User already disabled."; exit;}
    }
    Write-Host "User has been disabled!"
   
