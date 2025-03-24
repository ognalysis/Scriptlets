# Connect to Microsoft Graph to find DirSync settings.
# This took me 4 hours to figure out because the modules kept failing to load
# The reason I looked for this was to find out if the tenant I'm working in has UPN soft matching enabled
# Surprise: it's enabled by default
# This replaces any MSOL cmdlets

Connect-MgGraph -Scopes "OnPremDirectorySynchronization.Read.All"

$DirectorySync = Get-MgDirectoryOnPremiseSynchronization
$DirectorySync.Features.SoftMatchOnUpnEnabled
