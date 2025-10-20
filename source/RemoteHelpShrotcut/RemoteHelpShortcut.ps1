<#
This script creates a desktop shortcut named Remote Help.lnk on the Public Desktop. The shortcut:

Points to the Remote Help executable located at C:\Program Files\Remote Help\RemoteHelp.exe.
Uses the default icon from the executable (IconLocation = "$TargetPath, 0").
Does not perform any checks or logging—just creates the shortcut directly.
#>

$TargetPath = "C:\Program Files\Remote Help\RemoteHelp.exe"
$ShortcutPath = "$env:Public\Desktop\Remote Help.lnk"

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.IconLocation = "$TargetPath, 0"
$Shortcut.Save()