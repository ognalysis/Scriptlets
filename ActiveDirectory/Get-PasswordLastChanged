# Similar to my AD Manager, this grabs all users in a specific OU/Base
# and reports on all users who last changed their AD password 1 year ago
# (or whatever interval you want)

$SearchBase = "OU=USERS,DC=CONTOSO,DC=COM"
$HowLongAgo = (Get-Date).AddYears(-1) #Change to any .AddMinutes, .AddSeconds, or whatever interval you want
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$Users = get-ADUser -filter * -SearchBase $SearchBase -Properties *
$Report = [System.Collections.Generic.List[Object]]::new()

foreach ($User in $Users){
    if ($User.Enabled -eq $true){
        if ($User.PasswordLastSet -le $HowLongAgo) {
            $Report.Add($User)
        }
    }
}

$Report | Sort-Object -Property PasswordLastSet | ft -Property DisplayName,PasswordLastSet,@{n="Email";e={($_.mail)}},@{n="Manager"; e={(Get-ADUser $_.manager).name}} -AutoSize
$stopwatch.Stop(); Write-Host -NoNewline "Total Time (Seconds):" ($stopwatch.Elapsed.Seconds)
