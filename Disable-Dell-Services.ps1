#Requires -RunAsAdministrator

$services = Get-Service | where -Property DisplayName -Match "^Dell*"

Foreach ($s in $services){
    
    # Stop Services
    if ($s -ne $null -and $s.status -eq "Running"){ Stop-Service $s }
    elseif ($s -eq $null) { Write-Host "Serivce '$s' not found." }
    else { Write-Host "Service '$s' is already stopped." }

    # Set Services to Manual
    Set-Service -Name $s.Name -StartupType Manual
}