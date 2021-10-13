
#Sends users and e-mail notification when their AD password is about to expire
#Used primarily for off domain users

$daystillexpired = 3
$searchBase = "ou=ou,ou=ou,dc=dc,dc=dc"
$productionUsers = Get-ADUser -filter * -properties * -Searchbase $searchBase | Where-Object {$_.Enabled -eq "True"} | Where-Object {$_.passwordexpired -eq $false}
$testUsers = "user1","user2","user3"

foreach ($user in $testUsers){
        $user = Get-ADUser $user
        $name = (Get-ADUser $user | ForEach-Object {$_.Name})
        $email = $user.emailaddress
        $passwordSetDate = (Get-ADUser $user -properties * | ForEach-Object {$_.PasswordLastSet})
        $maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
        $expireDate = $passwordSetDate + $maxPasswordAge
        $today = (get-date)
        $daysToExpire = (New-TimeSpan -Start $today -End $expireDate).Days
        #if (($daysToExpire -le $daystillexpired) -or ($daysToExpire -eq "0")){
                $emailSubject = "Password Expiration Notice"
                $emailBody = "
                Dear $name,
                <p> Your  password expires in $daysToExpire.<br />
                To change your password please visit  <br /></p>

                <p>If you do not update your password by $expireDate then you will be unable to login.<br /></p>

                <p>This is an automated message, please do not reply.  If you have any issues or require assistance please contact us at admins@smartcop.com.<br /></p>"

                $smtp = ""
                $to = $email
                $from = ""
                $subject = $emailSubject
                $body = $emailBody

                send-MailMessage -SmtpServer $smtp -To $to -From $from -Subject $subject -Body $body -BodyAsHtml
        #    }

    }
