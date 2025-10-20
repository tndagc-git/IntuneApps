<#
This script checks whether the SentinelOne agent is installed by looking for the SentinelAgent service:

If the service exists, it outputs "SentinelOne is installed" and exits with code 0 (success).
If the service does not exist, it outputs "SentinelOne is not installed" and exits with code 1 (failure).
#>

$s1 = Get-Service "SentinelAgent" -ErrorAction SilentlyContinue
If ($s1) { Write-Output "SentinelOne is installed"; exit 0 }
Else { Write-Output "SentinelOne is not installed"; exit 1 }
