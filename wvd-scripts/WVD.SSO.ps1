Start-Transcript -Path "C:\WVD\WVD.SSO.log" -Force

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon"))
{
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\microsoftazuread-sso.com\autologon" -Name "https" -Value 1 -PropertyType DWord -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" -Name "2103" -Value 3 -PropertyType DWord -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge"))
{
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "AuthServerAllowlist" -Value "*microsoftazuread-sso.com" -PropertyType String -Force -Verbose

Stop-Transcript
