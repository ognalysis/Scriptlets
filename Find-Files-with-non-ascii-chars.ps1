$Path = "C:\"
$Regex = "[^\x00-\x7F]+"
Get-ChildItem -Path $Path -Recurse | Where-Object { $_.Name -match $Regex } -ErrorAction SilentlyContinue