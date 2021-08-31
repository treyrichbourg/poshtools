# Comment out Lines 4-8 and uncomment Line 2 to automate the server list - but be warned that it will inclue all servers (even your print server)
$servers = (Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties Name | Sort-Object -Property Name).name

#$servers = @(
#'Server 1'
#'Server 2'
#'Server 3'
#)

foreach ($server in $servers) {
Get-Service Spooler -ComputerName $server -ErrorAction SilentlyContinue | Stop-Service -PassThru -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled -ErrorAction SilentlyContinue
$ServiceStatus = (Get-Service Spooler -ComputerName $server -ErrorAction SilentlyContinue).Status
Write-Host $server $ServiceStatus
}