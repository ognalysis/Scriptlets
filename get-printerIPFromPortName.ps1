$SRV = Read-Host -Prompt "Enter Server Name"
invoke-command -computername $SRV -credential ${Get-Credential} -scriptBlock {
    $printerName = Read-Host -Prompt "Enter Printer Name"
    $printer = Get-Printer -Name $printerName | select PortName
    Get-PrinterPort -Name $printer.PortName | ft DeviceURL    
}