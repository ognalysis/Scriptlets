try {$Creds = Get-Credential}
catch {Write-Host -BackgroundColor Red -ForegroundColor Black "Please provide credentials"; exit;}

$RemoteClients = "ITAPPS"
$Services = "ADSync","AzureADConnectHealthSyncInsights","AzureADConnectHealthSyncMonitor"

foreach ($client in $RemoteClients){
    Invoke-command -ComputerName $client -Credential $Creds -ScriptBlock {
        foreach ($srv in $Services){
            try {Restart-Service $srv}
            catch {Write-Host -BackgroundColor Red -ForegroundColor Black "Some error occurred. Looks like you'll have to do this the hard way."; continue;}
            if ((get-service $srv).status -eq "Running"){ Write-Host -BackgroundColor Green -ForegroundColor Black "$srv has started!"}
        }
    }
}
