#Define OU to begin search
$OU="OU=??,DC=??,DC=??"

#Define a work folder for the report
$WorkFolder="C:\Admin"

#Define # of days to search for users that have not logged in
$Days=30

#Report file
$ExportedReport = "$WorkFolder\$DaysDayEnabledUsers.csv"

#Search for users
Get-ADUser -Filter {Enabled -eq $TRUE} -SearchBase $OU -Properties Name,SamAccountName,LastLogonDate | Where {($_.LastLogonDate -lt (Get-Date).AddDays(-$Days)) -and ($_.LastLogonDate -ne $NULL)} | Sort | Select Name,SamAccountName,LastLogonDate | export-csv $ExportedReport -nti



<#===========================
Send email 
=============================#>
$SMTPsettings = @{
	To =  "to@domain.com"
	Cc =  "cc@domain.com"
	From = "donotreply@domain.com"
	Subject = "$Days Day Inactive User List as of $(Get-Date -Format D)"
	Body = "The script to find inactive accounts has been run. The resultant file is attached."
	SmtpServer = "SMTPserver"
	}

Send-MailMessage @SMTPsettings -Bodyashtml -Attachments $ExportedReport