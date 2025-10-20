<#
This script:
Ensures a folder exists for storing a custom icon.
Copies the icon to that folder.
Creates a desktop shortcut to a CivicEye login page using that icon.
#>

$TargetPath = "https://tndag.civiceye.com/signin?r=/"
$ShortcutPath = "$env:PUBLIC\Desktop\CivicEye.lnk"
$IconFolder = "$env:ProgramData\IconFolder"
$IconPath = "$IconFolder\CivicEye.ico"

# Ensure the folder exists
if (!(Test-Path $IconFolder)) {
    New-Item -ItemType Directory -Path $IconFolder -Force
}

# Copy the icon
Copy-Item -Path "$PSScriptRoot\CivicEye.ico" -Destination $IconPath -Force

# Create the shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()
