Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -Verbose
New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.OneDrive.log" -Force

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "SilentAccountConfig" -Value 1 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "FilesOnDemandEnabled" -Value 1 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMSilentOptin" -Value "55fa1a18-7257-4a01-ba69-b5023cc47f9a" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMSilentOptinWithNotification" -Value 1 -PropertyType DWord -Force -Verbose
# New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMOptInWithWizard" -Value "55fa1a18-7257-4a01-ba69-b5023cc47f9a" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive " -Value "C:\Program Files (x86)\Microsoft OneDrive\OneDrive.exe /background" -PropertyType String -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce"))
{
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Force -Verbose
}

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "OneDrive" -Value "C:\\Program Files (x86)\\Microsoft OneDrive\\OneDrive.exe /background" -PropertyType String -Force -Verbose

if($False -eq (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\OneDrive"))
{
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Force -Verbose
}

New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\OneDrive" -Name "EnableADAL" -Value 1 -PropertyType DWord -Force -Verbose

Stop-Transcript
