# Based off this: https://learn.microsoft.com/en-us/answers/questions/1343593/users-with-mfa-enabled-disabled-enforced
# Redesigned to fit my preferred output formatting and simplicity with the code.


#Install necessary modules
#Install-Module -Name AzureAD -Force -AllowClobber
#Install-Module -Name MSOnline -Force -AllowClobber

#Import Modules
#Import-Module AzureAD
#Import-Module MSOnline

Connect-AzureAD
Connect-MsolService

# Fetch all users
$users = Get-AzureADUser -All $true

#DEBUG top 10
#$users = Get-AzureADUser -Top 10

# Define MFA Types list
$AuthTypes = "PhoneAppOTP", "PhoneAppNotification", "OneWaySMS", "TwoWayVoiceMobile"

# Array that contains each row of the custom object
$DATA = @()

# Iterate through each user to parse out the data
foreach ($user in $users) {

    # Write basic data to results, and define MFA values
    $Results = [PSCustomObject]@{
        DisplayName = $user.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        Mail = $User.Mail
        CreationType = $user.CreationType
        Enabled = $user.AccountEnabled
        MFAState = ""
        PhoneAppOTP = ""
        PhoneAppNotification = ""
        OneWaySMS = ""
        TwoWayVoiceMobile = ""        
    }

    # Fetch the MFA state
    $Results.MFAState = (Get-MsolUser -UserPrincipalName $user.UserPrincipalName).StrongAuthenticationRequirements.State
    
    # Get the authentication methods used by the user
    $strongAuthMethods = (Get-MsolUser -UserPrincipalName $user.UserPrincipalName).StrongAuthenticationMethods

    # For each MFA Auth Type, check if the user is using it and if it's the default.
    # If it's the default, label default. Otherwise, just label enabled.
    foreach ($type in $AuthTypes) {
        foreach ($method in $strongAuthMethods){
            if ($method.MethodType -eq $type) 
            { 
                    if ($method.IsDefault -eq "TRUE") { $Results.$type = "ENABLED(DEFAULT)" }
                    else {$Results.$type = "ENABLED"}
            }
        }
    }

    $DATA += $Results
}

$DATA | export-csv -NoTypeInformation -Path "$env:USERPROFILE\Downloads\AzureMFAExport-$(Get-Date -Format "yyyy-MM-dd").csv"