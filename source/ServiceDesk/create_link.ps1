<#
This script creates a desktop shortcut named ServiceDesk.lnk on the Public Desktop that:

Opens the ServiceDesk web page at https://dash.tndagc.org/WOListView.do.
Uses a custom icon (ServiceDesk.ico) stored in C:\ProgramData\IconFolder.
Ensures the icon folder exists and copies the icon from the script's directory.
Uses WScript.Shell to generate the shortcut with the specified target and icon.
#>

$TargetPath = "https://dash.tndagc.org/WOListView.do"
$ShortcutPath = "$env:PUBLIC\Desktop\ServiceDesk.lnk"
$IconFolder = "$env:ProgramData\IconFolder"
$IconPath = "$IconFolder\ServiceDesk.ico"

# Ensure the folder exists
if (!(Test-Path $IconFolder)) {
    New-Item -ItemType Directory -Path $IconFolder -Force
}

# Copy the icon
Copy-Item -Path "$PSScriptRoot\ServiceDesk.ico" -Destination $IconPath -Force

# Create the shortcut
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.IconLocation = $IconPath
$Shortcut.Save()
