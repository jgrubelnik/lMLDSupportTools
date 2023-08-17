# lMLDSupportTools

# Usefull Urls
```
# https://learn.microsoft.com/en-us/troubleshoot/windows-client/networking/intranet-site-identified-as-an-internet-site
# https://stackoverflow.com/questions/68799849/add-trusted-file-share-to-internet-explorer
# https://gist.github.com/altrive/9319551 --> example for PS1 Script Adding Iexplore Settings
# https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.InternetExplorer::IZ_PolicyInternetZoneTemplate
```
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

$KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\"  
$ValueName = "$zone"
$ValueData = "$ipAddress"  
try{  
    Get-ItemProperty -Path $KeyPath -Name $valueName -ErrorAction Stop  
}  
catch [System.Management.Automation.ItemNotFoundException] {  
    New-Item -Path $KeyPath -Force
    New-ItemProperty -Path $KeyPath -Name $ValueName -Value $ValueData -Force
}  
catch {  
    New-ItemProperty -Path $KeyPath -Name $ValueName -Value $ValueData -Type String -Force
}  
```
