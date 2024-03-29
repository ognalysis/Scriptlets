$SearchBase = "OU=USERS,DC=CONTOSO,DC=COM"
$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$Users = get-ADUser -filter * -SearchBase $SearchBase -Properties *
$Report = [System.Collections.Generic.List[Object]]::new()
foreach ($User in $Users){
    if ($User.Enabled -eq $true){ #Change to $false for disabled users
        if ($User.Manager -match "John Smith") {
            $Report.Add($User)
        }
    }
}
# Sorts Alphabetically by Name; displays Name, UPN, and Manager name.
$Report | Sort-Object -Property UserPrincipalName | ft -Property DisplayName,@{n="Email";e={($_.Mail)}},@{n="Manager"; e={(Get-ADUser $_.manager).name}} -AutoSize
$stopwatch.Stop(); Write-Host -NoNewline "Total Time (Seconds):" ($stopwatch.Elapsed.Seconds)
