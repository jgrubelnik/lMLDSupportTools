# lMLDSupportTools

## TODO's
Auslesen von installierter Software "explusive" Microsoft 
Integration dieses Powershell befehls in das check/Monitor Script 
```
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where-object { $_.DisplayName -notlike "*microsoft*" } | select-object DisplayName, DisplayVersion, Publisher, InstallDate |
>> Format-Table -AutoSize
```
Füge Regeln zu den Lokalen Intranet Sites hinzu 
```
$ipAddress = "192.168.100.11"
$zone = 1  # 1 steht für "Lokales Intranet"

# Hinzufügen der IP-Adresse zur lokalen Intranet-Zone
Add-Content -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\$zone" -Value "$ipAddress=2"
```
