<#
This script creates a desktop shortcut named eAgent-favicon.lnk on the Public Desktop that:

Opens the eAgent web portal at http://tbieagent.diversecomputing.net.
Uses a custom icon (eAgent-favicon.ico) stored in C:\ProgramData\IconFolder.
Ensures the icon folder exists and copies the icon from the script's directory.
Uses WScript.Shell to generate the shortcut with the specified target and icon.
#>

$TargetPath = "http://tbieagent.diversecomputing.net"
$ShortcutPath = "$env:PUBLIC\Desktop\eAgent-favicon.lnk"
$IconFolder = "$env:ProgramData\IconFolder"
$IconPath = "$IconFolder\eAgent-favicon.ico"

# Ensure the folder exists
if (!(Test-Path $IconFolder)) {
    New-Item -ItemType Directory -Path $IconFolder -Force
}

# Copy the icon
Copy-Item -Path "$PSScriptRoot\eAgent-favicon.ico" -Destination $IconPath -Force

# Create the shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()
