<#
This script creates two desktop shortcuts on the current user's desktop. Each shortcut points to a network folder hosted at \\172.16.6.7:

One shortcut links to \\172.16.6.7\Jonesborough\Scans
The other links to \\172.16.6.7\Jonesborough\Multimedia

It uses the WScript.Shell COM object to generate .lnk files and confirms their creation with output messages.
#>

# === Define Variables ===
$server = "\\172.16.6.7"
$folder = "Jonesborough"
$subfolder1 = "Scans"
$subfolder2 = "Multimedia"

# Build target paths
$target1 = Join-Path "$server\$folder" $subfolder1
$target2 = Join-Path "$server\$folder" $subfolder2

# Define shortcut names and location (e.g., Desktop)
$desktop = [Environment]::GetFolderPath("Desktop")
$shortcut1 = Join-Path $desktop "$folder-$subfolder1.lnk"
$shortcut2 = Join-Path $desktop "$folder-$subfolder2.lnk"

# Create WScript.Shell COM object
$wShell = New-Object -ComObject WScript.Shell

# Create first shortcut
$link1 = $wShell.CreateShortcut($shortcut1)
$link1.TargetPath = $target1
$link1.Save()

# Create second shortcut
$link2 = $wShell.CreateShortcut($shortcut2)
$link2.TargetPath = $target2
$link2.Save()

Write-Host "Shortcuts created on Desktop:"
Write-Host " - $shortcut1 on $target1"
Write-Host " - $shortcut2 on $target2"
