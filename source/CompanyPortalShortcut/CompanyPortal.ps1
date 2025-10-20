<#
This script creates a desktop shortcut named CompanyPortal.lnk 
on the Public Desktop. The shortcut points to the Microsoft Company Portal app 
using its shell path (shell:AppsFolder\...). 
It does not set a custom icon or perform any checks—just creates the shortcut directly.
#>

$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut("$env:Public\Desktop\CompanyPortal.lnk")
$Shortcut.TargetPath = "shell:AppsFolder\Microsoft.CompanyPortal_8wekyb3d8bbwe!App"
$Shortcut.Save()
