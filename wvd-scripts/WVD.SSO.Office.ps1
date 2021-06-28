param(
    [String]$TenantId
)

Start-Transcript -Path "C:\WVD\WVD.SSO.Office.log" -Force

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "SilentAccountConfig" -Value 1 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "FilesOnDemandEnabled" -Value 1 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMSilentOptin" -Value $TenantId -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMSilentOptinWithNotification" -Value 1 -PropertyType DWord -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDrive " -Value "C:\Program Files (x86)\Microsoft OneDrive\OneDrive.exe /background" -PropertyType String -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce"))
{
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Force -Verbose
}

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "OneDrive" -Value "C:\\Program Files (x86)\\Microsoft OneDrive\\OneDrive.exe /background" -PropertyType String -Force -Verbose

Stop-Transcript
