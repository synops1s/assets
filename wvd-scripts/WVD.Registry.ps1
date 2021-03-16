param(
    [String]$TenantId
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Registry.log" -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Value 1 -PropertyType DWord -Force -Verbose

# HKCU\Software\Policies\Microsoft\office\16.0\Common\General:PreferCloudSaveLocations:DWORD:00000001

# Hide Drives A,B,C = 0x00000007
# Hide Drives A,B,C,D = 0x0000000F
# Hide Drives ALL = 0x03FFFFFF
# HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer:NoDrives:DWORD:00000007

# HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer:NoViewContextMenu:DWORD:00000001
# HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer:NoNetConnectDisconnect:DWORD:00000001
# HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer:NoManageMyComputerVerb:DWORD:00000001

# HKCU\SOFTWARE\Classes\Folder\shell\opennewwindow:Extended:DWORD:00000001
New-Item -Path "Registry::HKEY_CURRENT_USER\Software\Classes\Folder\shell\opennewwindow" -Force -Verbose
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Classes\Folder\shell\opennewwindow" -Name "Extended" -Value "" -PropertyType String -Force -Verbose

# HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag

## TESTED ##

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Value 1 -PropertyType DWord -Force -Verbose

Stop-Transcript

# @ECHO OFF  
# DEL "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft OneDrive.lnk"  
# DEL "%APPDATA%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"  
# DEL "%USERPROFILE%\Links\OneDrive.lnk"

# Stop-Process -ProcessName "OneDrive"
# Set-Location "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"  
# Get-ChildItem | ForEach-Object {Get-ItemProperty $_.pspath} | ForEach-Object {  
#     $leftnavNodeName = $_."(default)";  

# if (($leftnavNodeName -eq "OneDrive") -Or ($leftnavNodeName -eq "OneDrive - Personal")) {  
#         if (Test-Path $_.pspath) {  
#             Remove-Item $_.pspath;  
#         }  
#     }  
# }
