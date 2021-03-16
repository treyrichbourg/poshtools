#Searches AD for enabled accounts that haven't been logged on in X amount of days.
param (
    [int]$Days=30
)

#Search for users
function last_logon {
    Get-ADUser -Filter {Enabled -eq $TRUE} -Properties Name,SamAccountName,LastLogonDate,DistinguishedName | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-$Days)) -and ($_.LastLogonDate -ne $NULL)} | Sort | Select Name,SamAccountName,LastLogonDate,DistinguishedName | out-gridview -Title "Users not logged on in $Days days"
}

last_logon ($Days)