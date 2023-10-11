Function Set-UserProxyAddresses {
<#
.SYNOPSIS
    Clears and sets ProxyAddress attribute for the user passed to it.
 
 
.NOTES
    Date Created 2023-Apr-12
     
 
.EXAMPLE
    Set-UserProxyAddresses -UserPrincipalName <username> -Credential <$Credential>
 
 
.LINK
    https://thesysadminchannel.com/powershell-template -
#>
 
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true
            )]
            [ValidateScript( {Get-ADUser -Filter "SamAccountName -eq '$_'" | select -ExpandProperty SamAccountName} )]
            [String[]]$UserPrincipalName,

        [Parameter(
            Mandatory = $true
            )]
            [System.Management.Automation.PSCredential]$Credential
    )
 
    BEGIN {}
 
    PROCESS {
        # Get User object you're modifying
        $user = Get-ADUser $UserPrincipalName -Properties Name,ProxyAddresses -ErrorAction Stop

        # Clear the Existing ProxyAddresses
        Write-Host "Clearing Existing Addresses"
        #Set-ADUser $user -Clear ProxyAddresses -Credential $Credential -errorAction Stop

        # Set the ProxyAddress Format String
        $proxyaddresses = "smtp:$($user.SamAccountName)@bixbytelephone.com", "SMTP:$($user.SamAccountName)@mybtc.com"
        $proxyaddresses

        # Add the ProxyAddresses string to the user object
        #foreach ($addr in $proxyaddresses){ Set-aduser -Identity $user -Add @{proxyaddresses = "$addr"} -Credential $Credential -ErrorAction Stop};

        # See the new updated data
        Get-ADUser $user.SamAccountName -Properties proxyaddresses -ErrorAction Stop | select-Object Name,@{n="ProxyAddresses";e= { $_.ProxyAddresses -join ";"}}
    
    }
 
    END {}
}
