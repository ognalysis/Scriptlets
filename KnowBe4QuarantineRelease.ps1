Connect-ExchangeOnline

$daysago = (Get-Date).AddDays(-6).ToString("MM/dd/yyyy")

$Tomorrow = (Get-Date).AddDays(1).ToString("MM/dd/yyyy")

$Quarantine = Get-QuarantineMessage -StartReceivedDate $daysago -EndReceivedDate $Tomorrow -PageSize 1000

<#
#$Header = Get-QuarantineMessageHeader -Identity $Quarantine[0].Identity

$authorized_IPs = @("23.21.109.197","23.21.109.212")

foreach ($x in $Quarantine){
    foreach ($ip in $authorized_IPs){
        $Header = Get-QuarantineMessageHeader -Identity $x.Identity
        if ($Header.Header -like "*Authentication-Results: spf=* (sender IP is $ip)*") {
            echo "$($x.MessageId) Matches $($ip)"
        }
    }
}
#>

$results = @()

foreach ($message in $Quarantine) {
    if ($message.MessageId.ToString() -like "*@psm.knowbe4.com>"){
        $results += $message
    }
}

foreach ($item in $results) {
    if ($item.ReleaseStatus -eq "NOTRELEASED"){
        Get-QuarantineMessage -MessageID $item.MessageId | Release-QuarantineMessage -ReleaseToAll -ReportFalsePositive
        Write-Host "Received: $($item.ReceivedTime) - Message $($item.MessageId) - Subject: $($item.Subject) - Status: Released";
    }
}

Disconnect-ExchangeOnline -Confirm:$false
