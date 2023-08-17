# lMLDSupportTools

## TODO's
Auslesen von installierter Software "explusive" Microsoft 
Integration dieses Powershell befehls in das check/Monitor Script 
```Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where-object { $_.DisplayName -notlike "*microsoft*" } | select-object DisplayName, DisplayVersion, Publisher, InstallDate |
>> Format-Table -AutoSize
```
