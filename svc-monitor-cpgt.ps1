# List of names to check (services or processes)
$NamesToCheck = @(
    "wuauserv",   # Example: Windows Update service
    "Spooler",    # Example: Print Spooler service
    "explorer"    # Example: Explorer process
	"FakeService" # Example: Doesn't exist
)

# Loop until all are running
do {
    Clear-Host
    Write-Host "Checking service status... (Refreshed $(Get-Date -Format 'HH:mm:ss'))" -ForegroundColor Cyan
    Write-Host ""

    $allRunning = $true

    foreach ($name in $ServicesToCheck) {
        $service = Get-Service -Name $name -ErrorAction SilentlyContinue
        if ($service) {
            $status = $service.Status
            if ($status -ne "Running") { $allRunning = $false }
            Write-Host ("[Service] {0,-20} : {1}" -f $name, $status) -ForegroundColor $(if ($status -eq "Running") {"Green"} else {"Red"})
        }
        else {
            $allRunning = $true
            Write-Host ("[Service] {0,-20} : Not Found" -f $name) -ForegroundColor DarkGray
        }
    }

    if (-not $allRunning) {
        Write-Host ""
        Write-Host "Not all services are running. Refreshing in 15 seconds..." -ForegroundColor Yellow
        Start-Sleep -Seconds 15
    }

} until ($allRunning)

Write-Host ""
Write-Host "✅ All services are running!" -ForegroundColor Green
