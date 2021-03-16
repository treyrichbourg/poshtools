#Searches an OU for enabled accounts that haven't been logged on in X amount of days.
param (
    [string]$OU="OU=??,DC=??,DC=??",
    [int]$Days=30
)

#Search for users
function last_logon {
    Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase $OU -Properties Name,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-$Days)) -and ($_.LastLogonDate -ne $NULL)} | Sort | Select Name,SamAccountName,LastLogonDate | out-gridview
}

last_logon ($OU, $Days)