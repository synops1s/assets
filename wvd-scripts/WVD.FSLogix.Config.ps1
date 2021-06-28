param(
    [String]$SharePath
)

Start-Transcript -Path "C:\WVD\WVD.FSLogix.Config.log" -Force

$FSLogixUNCPath = Join-Path -Path $SharePath -ChildPath "fslogixprofiles" -Verbose

# Add FSLogix Settings
New-Item -Path HKLM:\Software\FSLogix -Name Profiles -Force -Verbose
New-Item -Path HKLM:\Software\FSLogix -Name Apps -Force -Verbose
New-Item -Path HKLM:\Software\Policies\FSLogix -Name ODFC -Force -Verbose

New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "Enabled" -Value "1" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "VHDLocations" -Value $FSLogixUNCPath -PropertyType MultiString -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "SizeInMBs" -Value "32768" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "IsDynamic" -Value "1" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "VolumeType" -Value "vhdx" -PropertyType String -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "LockedRetryCount" -Value "12" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "LockedRetryInterval" -Value "5" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "ProfileType" -Value "3" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "ConcurrentUserSessions" -Value "1" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "RoamSearch" -Value "0"  -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\FSLogix\Apps -Name "RoamSearch" -Value "0" -PropertyType DWord -Force -Verbose
New-ItemProperty -Path HKLM:\Software\Policies\FSLogix\ODFC -Name "RoamSearch" -Value "0"  -PropertyType DWord -Force -Verbose

Get-LocalGroupMember -Group "FSLogix Profile Include List" | ForEach-Object { Remove-LocalGroupMember -Group "FSLogix Profile Include List" -Member $_.Name }
Add-LocalGroupMember -Group "FSLogix Profile Include List" -Member (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "DomainUserGroup")
Get-LocalGroupMember -Group "FSLogix Profile Exclude List" | ForEach-Object { Remove-LocalGroupMember -Group "FSLogix Profile Exclude List" -Member $_.Name }

Get-LocalGroupMember -Group "FSLogix ODFC Include List" | ForEach-Object { Remove-LocalGroupMember -Group "FSLogix ODFC Include List" -Member $_.Name }
Add-LocalGroupMember -Group "FSLogix ODFC Include List" -Member (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "DomainUserGroup")
Get-LocalGroupMember -Group "FSLogix ODFC Exclude List" | ForEach-Object { Remove-LocalGroupMember -Group "FSLogix ODFC Exclude List" -Member $_.Name }

Stop-Transcript
