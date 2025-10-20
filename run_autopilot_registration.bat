@echo off
:: Run PowerShell as Administrator and execute commands, keeping the window open
powershell -Command "Start-Process PowerShell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command \"Set-ExecutionPolicy Bypass -Scope Process -Force; Install-Script -Name Get-WindowsAutopilotInfo -Force; Get-WindowsAutopilotInfo -Online\"'"
