#==========================================================================
#
# NAME: WSUS_Server_Check-in.ps1
#
# AUTHOR: Srikesh Maharaj    
#
# COMMENT: This script will connect to the WSUS server specified in the $wsusServer variable and use the port specified in the $wsusPort variable. It will then retrieve a list of all computers that are managed by WSUS, 
#          and filter this list to include only those that have not checked in within the past 7 days. Finally, it will output the full domain name and last reported status time for each of these computers.
#          You can modify this script as needed to suit your specific requirements. For example, you may want to adjust the number of days used to filter the list of computers, or add additional filtering criteria.
#          I hope this helps. Let me know if you have any questions.

$wsusServer = "ENTER YOUR WSUS SERVER FQDN HERE"
$wsusPort = "ENTER YOUR WSUS PORT NUMBER HERE IF NOT DEFAULT"

$date = (Get-Date).AddDays(-7)

$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope

$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::getUpdateServer($wsusServer, $false, $wsusPort)

$computers = $wsus.GetComputerTargetGroups() | Where-Object {$_.Name -eq "All Computers"}
$computers = $computers.GetComputerTargets()
$computers = $computers | Where-Object {$_.LastReportedStatusTime -lt $date}

$computers | Select-Object FullDomainName,LastReportedStatusTime |  Export-Csv -Path "C:\WSUS\WSUS_Server_Check-in_Report.csv" -Append -NoTypeInformation
