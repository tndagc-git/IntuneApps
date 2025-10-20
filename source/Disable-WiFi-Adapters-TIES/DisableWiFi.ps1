<#
This script disables all active Wi-Fi adapters on the system and logs the actions to a file in the user's profile. It:

Identifies Wi-Fi adapters that are not already disabled.
Disables each one using Disable-NetAdapter.
Logs the before and after status of each adapter to a text file.
Creates a flag file (WiFiDisabled.flag) in C:\ProgramData to mark that the operation was performed.
#>

# Define log file path
$logFile = "$env:USERPROFILE\wifi_adapter_disable_log.txt"

# Get all Wi-Fi adapters that are not already disabled
$wifiAdapters = Get-NetAdapter | Where-Object {
    $_.InterfaceDescription -match "Wi-Fi" -and $_.Status -ne "Disabled"
}

# Disable each adapter and log status
foreach ($adapter in $wifiAdapters) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - Disabling adapter: $($adapter.Name) (Current Status: $($adapter.Status))"
    Write-Host $logEntry
    Add-Content -Path $logFile -Value $logEntry

    Disable-NetAdapter -Name $adapter.Name -Confirm:$false

    # Wait briefly to allow status update
    Start-Sleep -Seconds 2

    # Re-check adapter status
    $updatedAdapter = Get-NetAdapter -Name $adapter.Name
    $statusEntry = "$timestamp - Adapter '$($updatedAdapter.Name)' new status: $($updatedAdapter.Status)"
    Write-Host $statusEntry
    Add-Content -Path $logFile -Value $statusEntry
}

# Create marker file for detection
New-Item -Path "C:\ProgramData\WiFiDisabled.flag" -ItemType File -Force
