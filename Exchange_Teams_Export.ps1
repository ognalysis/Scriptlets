# Imports & Installs
Add-Type -AssemblyName PresentationFramework

#Check if PS is running as admin
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
    [System.Windows.MessageBox]::Show("You need to run this script as an Administrator",'Needs Administrator','Ok','Error')
    exit
}

# Check if Exchange Online management module is installed
if (!(Get-Module -ListAvailable -Name ExchangeOnlineManagement)){
    $Response = [System.Windows.MessageBox]::Show("ExchangeOnlineManagement Module is not installed.`nThis is required to continue.`nWould you like to install it?",'Status', 4)
    if ($Response -eq "Yes"){Install-Module ExchangeOnlineManagement}else {exit;}
}

# Check if Export Tool is installed
$ExportTool = Get-ChildItem -Path $env:LOCALAPPDATA -Include "microsoft.office.client.discovery.unifiedexporttool.exe" -Recurse -ErrorAction SilentlyContinue
if ($ExportTool -eq $null){[System.Windows.MessageBox]::Show("You need to download the eDiscovery Export Tool before running this script.",'eDiscovery Export Tool Needed!','Ok','Error');exit;}
#if (!(Test-Path -Path "$($ExportTool[0].FullName)")){[System.Windows.MessageBox]::Show("You need to download the eDiscovery Export Tool before running this script.",'eDiscovery Export Tool Needed!','Ok','Error');exit;}

#Connect to ExchangeOnline Compliance Center
try {Connect-IPPSSession}
catch {[System.Windows.MessageBox]::Show("Something went wrong...",'365 Compliance','Ok','Error'); Disconnect-ExchangeOnline -Confirm:$false; exit}

# Connect to ExchangeOnline
try {Connect-ExchangeOnline -UserPrincipalName}
catch {[System.Windows.MessageBox]::Show("Something went wrong...",'ExchangeOnline','Ok','Error'); Disconnect-ExchangeOnline -Confirm:$false; exit}

# Function to validate email
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

# Get Email Address of User to Export
$email = Read-Host "Enter Email Address"

# Check that email is valid and if email exists.
$mailbox=$false
while (!$mailbox){
    while (!(IsValidEmail -Email $email)){Write-Host "Invalid Email..."; $email = Read-Host "Enter Email"}
    $mailbox = Get-EXOMailbox -Identity $email -ErrorAction SilentlyContinue
    if (!($mailbox)){Write-Host "Mailbox does not exist. Try again."; $email = Read-Host "Enter Email"}
}

# Search description
$Description = "Standard Email/Teams content export for Terminated Employees."

# Set download location to current user Downloads folder
$Downloads = "$($env:HOMEDRIVE)$($ENV:HOMEPATH)\Downloads"

# Create Search name
$ComplianceSearchName = "$($email.Split('@')[0])_$(Get-Date -UFormat '%B-%d-%Y')"

#TODO
# Check if mailbox is active or not. Run compliance search based on that. You have to use .$email for inactive boxes, and $email for active boxes 
#as per: https://docs.microsoft.com/en-us/powershell/module/exchange/new-compliancesearch?view=exchange-ps
# UPDATE: Not bothering with this right now, since there seems to be no way to distinguish between the two.
# I have no clue why searching for inactive mailboxes was working before and now isn't.
# Searching active mailboxes does work, so I'm going with that.

# Create new compliance search and start, check if search already exists
try{New-ComplianceSearch -Name "$ComplianceSearchName" -ExchangeLocation "$email" -Description $Description -AllowNotFoundExchangeLocationsEnabled $true -ErrorAction stop | Start-ComplianceSearch -ErrorAction stop}
catch {[System.Windows.MessageBox]::Show("Something went wrong...`nItem may already exist by that name.`nCheck Compliance Center and run script again.",'New Compliance Search','Ok','Error'); Disconnect-ExchangeOnline -Confirm:$false; exit}

# Wait for Compliance Search to be ready.
Write-host "$((Get-ComplianceSearch $ComplianceSearchName).Status) Compliance Search..." -NoNewline
do {
    $sta = $(Get-ComplianceSearch $ComplianceSearchName).Status
    Write-Host -NoNewline "."; Start-Sleep -Seconds 5
} while ($sta -ne "Completed")
Write-host "`n$((Get-ComplianceSearch $ComplianceSearchName).Status) Compliance Search!";

# Check if the search is empty
if ((Get-ComplianceSearch $ComplianceSearchName) -eq $null){
    $Response = [System.Windows.MessageBox]::Show("Compliance Search seems to be empty.`nI'm not built to handle this.`nTry running the search manually.`n`nWould you like to delete this search?",'Compliance Search Empty','yesNo','Error')
    if ($Response -eq "YES"){
        Remove-ComplianceSearch $ComplianceSearchName
        Disconnect-ExchangeOnline
        exit;
    } else { Disconnect-ExchangeOnline; exit; }
}

# Start the export
Write-Host "Starting Export..."
try {New-ComplianceSearchAction "$ComplianceSearchName" -Export -Format Fxstream }
catch {[System.Windows.MessageBox]::Show("Something went wrong...",'Compliance Export Action','Ok','Error'); <#Disconnect-ExchangeOnline -Confirm:$false; exit; #>}

# Wait for Export to finish
Write-Host "Waiting for 365 Compliance Search Export..."
while ((Get-ComplianceSearchAction "$($ComplianceSearchName)_Export").JobEndTime -eq $null){
    Write-host -NoNewline "."
    Start-Sleep -Seconds 120
}
Write-Host "Export Completed."

# Save results
$Results = (Get-ComplianceSearchAction "$($ComplianceSearchName)_Export" -IncludeCredential).Results

# Extract the Source URL
$containerUrl = $Results.Split(';')[0] -replace 'Container url: '

# Extract the SAS token URL
$tokenUrl = $Results.Split(';')[1] -replace ' SAS token: '

# Unused: combine to create full URL; Doesn't actually allow to download.
#$URL = $containerUrl + $tokenUrl
#$URL = ($Results.Split(';')[0] -replace 'Container url: ')+($Results.Split(';')[1] -replace ' SAS token: ')

# Executable options
<#
Usage: microsoft.office.client.discovery.unifiedexporttool.exe 
-name <Export Name> 
-Source <Source Endpoint> 
[-key <Export Key>] 
[-dest <Destination Path>] 
[-trace true|false|<trace file path>]
#>

Write-Host "Starting Export Download in $Downloads"
# Execute the tool with parameters
& $ExportTool[0].FullName -Name "$($ComplianceSearchName)_Export" -Source $ContainerUrl -key $tokenUrl -dest $Downloads -trace "$($Downloads)\$($ComplianceSearchName)_trace.txt"

try{
    $proc = Get-Process | where -Property name -EQ "microsoft.office.client.discovery.unifiedexporttool"
    while (!$Proc.HasExited){Write-Host "." -NoNewline; Start-Sleep -Seconds 60}
}
catch {[System.Windows.MessageBox]::Show("Process not found.`nDownload may have finished sooner`nthan the script could check for the Export Tool running...",'Weird Error','Ok'); Disconnect-ExchangeOnline; exit;}
#$proc.HasExited

[System.Windows.MessageBox]::Show("Download Completed!",'Success!','Ok')
explorer "$Downloads\$($ComplianceSearchName)_Export"

#OPTIONAL TODO
# Delete compliance search when finished?
