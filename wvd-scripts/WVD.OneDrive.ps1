Start-Transcript -Path "C:\WVD\WVD.OneDrive.log"

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "SilentAccountConfig" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "FilesOnDemandEnabled" -Value 1 -PropertyType DWORD -Force

if($False -eq (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce"))
{
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Force
}

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "OneDrive" -Value "C:\\Program Files (x86)\\Microsoft OneDrive\\OneDrive.exe /background" -PropertyType String -Force

if($False -eq (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\OneDrive"))
{
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Force
}

New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Name "EnableADAL" -Value 2 -PropertyType DWORD -Force

Stop-Transcript
