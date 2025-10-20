<#
This script enables all Wi-Fi adapters that are currently not in the "Up" state and logs the process:

Identifies Wi-Fi adapters that are disabled or down.
Attempts to enable each one using Enable-NetAdapter.
Logs the before and after status of each adapter to a log file in the user's profile.
Creates a flag file (WiFiEnabled.flag) in C:\ProgramData to indicate the operation was completed.
#>

# Define log file path
$logFile = "$env:USERPROFILE\wifi_adapter_log.txt"

# Get all Wi-Fi adapters that are not "Up"
$wifiAdapters = Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -match "Wi-Fi" -and $_.Status -ne "Up"
}

# Enable each adapter and log status
foreach ($adapter in $wifiAdapters) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - Attempting to enable adapter: $($adapter.Name) (Status: $($adapter.Status))"
    Write-Host $logEntry
    Add-Content -Path $logFile -Value $logEntry

    Enable-NetAdapter -Name $adapter.Name -Confirm:$false
    # Wait briefly to allow status update
    Start-Sleep -Seconds 2

    # Re-check adapter status
    $updatedAdapter = Get-NetAdapter -Name $adapter.Name
    $statusEntry = "$timestamp - Adapter '$($updatedAdapter.Name)' new status: $($updatedAdapter.Status)"
    Write-Host $statusEntry
    Add-Content -Path $logFile -Value $statusEntry
}

# Create marker file for detection
New-Item -Path "C:\ProgramData\WiFiEnabled.flag" -ItemType File -Force
