# Function Author: Mathias R. Jessen
# Source: https://stackoverflow.com/questions/48253743/powershell-to-validate-email-addresses
function IsValidEmail {
    param([string]$EmailAddress)

    try {
        $null = [mailaddress]$EmailAddress
        return $true
    }
    catch { return $false }
}
Connect-ExchangeOnline
Write-host "This script is to disable a user mailbox AutoReply.`n" -ForegroundColor Black -BackgroundColor Yellow
do {
    $eml = Read-Host -Prompt "Enter user email address"

    if (IsValidEmail($eml)){
        $state = Get-EXOMailbox -Identity $eml | get-MailboxAutoReplyConfiguration
        If ($state.AutoReplyState -eq "Enabled") {
            Write-Host -BackgroundColor Yellow "AutoReply is enabled. Disabling Autoreply..."; 
            Set-MailboxAutoReplyConfiguration -Identity $eml -AutoReplyState Disabled;
            Write-host -BackgroundColor Green "AutoReply Disabled."
        }else {Write-Host -BackgroundColor Yellow -foregroundcolor black "AutoReply is not enabled."}

    }else { Write-Host -BackgroundColor Yellow -ForegroundColor Black "Invalid Email. Try again."`n`n; }

}while (!(IsValidEmail($eml)))
Disconnect-ExchangeOnline -Confirm:$false
