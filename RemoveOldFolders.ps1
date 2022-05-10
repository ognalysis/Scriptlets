$age = (Get-Date).AddDays(-7)
$path = "C:Users\JohnSmith\Desktop\"

Get-ChildItem -Path $path | foreach {
    Get-ChildItem -Path $_.FullName | foreach {
        if ($_.CreationTime -le $age){
            Remove-Item $_.FullName -Recurse -Force -Verbose -Confirm:$false
        }
    }
}
