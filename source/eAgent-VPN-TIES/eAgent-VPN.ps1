<#
This script sets up a Cisco AnyConnect VPN profile for the Cisco Secure Client:

Creates the required profile directory if it doesn't exist.
Writes a predefined VPN profile XML file (TIES_eAgent.xml) with server details.
Verifies the profile file was successfully created.
Attempts to restart the Cisco Secure Client service to apply the new profile.
If the service isn't found, it prompts the user to restart the client manually.
#>

#Requires -RunAsAdministrator

# Define paths and profile content
$ProfileDir = "C:\ProgramData\Cisco\Cisco Secure Client\VPN\Profile"
$ProfilePath = Join-Path -Path $ProfileDir -ChildPath "TIES_eAgent.xml"
$ProfileContent = @'
<?xml version="1.0" encoding="UTF-8"?>
<AnyConnectProfile xmlns="http://schemas.xmlsoap.org/encoding/">
    <ServerList>
        <HostEntry>
            <HostName>eAgent VPN</HostName>
            <HostAddress>tbivpn.diversecomputing.net:8443/eagentx2</HostAddress>
        </HostEntry>
    </ServerList>
</AnyConnectProfile>
'@

# Create profile directory if it doesn't exist
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
}

# Create and write the XML profile file
$ProfileContent | Out-File -FilePath $ProfilePath -Encoding utf8 -Force

# Verify the file was created
if (Test-Path $ProfilePath) {
    Write-Host "Profile created successfully at $ProfilePath"
} else {
    Write-Error "Failed to create profile at $ProfilePath"
    exit 1
}

# Restart Cisco Secure Client service
$ServiceName = "Cisco Secure Client - AnyConnect VPN"
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue
    Start-Service -Name $ServiceName -ErrorAction SilentlyContinue
    Write-Host "Cisco Secure Client service restarted"
} else {
    Write-Warning "Cisco Secure Client service not found. Please restart the client manually."
}