$dateToday = Get-Date -Format "MM-dd-yyyy"
$daysInactive = 180
$dateInactive = (Get-Date).Adddays(-($daysInactive))
$searchBase = 'OU=Desktops,DC=domain,DC=com'
$disabledOU = 'OU=Disabled,OU=Desktops,DC=domain,DC=com'

Write-Host -Foreground Yellow -Background Black "Building a list of inactive computers..."
$inactiveComputers = Search-ADAccount -AccountInactive -DateTime $dateInactive -ComputersOnly -SearchBase $searchBase | Where-Object {$_.Enabled -eq $true} | Select-Object Name,LastLogonDate,Enabled,DistinguishedName,ObjectGuid | Sort LastLogonDate

$generateReport = Read-Host 'Would you like to generate a report of inactive computers?(y/n)'

if ($generateReport -eq 'y') {
       Write-Host -Foreground Yellow -Background Black "Generating InactiveComputers.csv on the desktop..."
       $inactiveComputers | Export-Csv -Path $env:USERPROFILE\Desktop\InactiveComputers_$dateToday.csv
    }

$disableAndMove = Read-Host 'Would you like to disable inactive computers and move to the proper OU?(y/n)'

if ($disableAndMove -eq 'y') {
        Write-Host -Foreground Yellow -Background Black "Disabling Inactive Computers and moving them to $disabledOU"
        ForEach ($computer in $inactiveComputers) {
                $distName = $computer.DistinguishedName
                Set-ADComputer -Identity $distName -Enabled $false
                Move-ADObject -Identity $computer.ObjectGuid -TargetPath $disabledOU
                }
    }

Write-Host -Foreground Yellow -Background Black 'Finished cleaning inactive computers.'

