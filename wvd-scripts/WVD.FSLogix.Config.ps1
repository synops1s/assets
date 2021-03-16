param(
    [String]$SharePath
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.FSLogix.Config.log" -Force

$FSLogixUNCPath = Join-Path -Path $SharePath -ChildPath "fslogixprofiles" -Verbose

# Add FSLogix Settings
New-Item -Path HKLM:\Software\FSLogix\ -Name Profiles -Force -Verbose
New-Item -Path HKLM:\Software\FSLogix\Profiles\ -Name Apps -Force -Verbose

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

Stop-Transcript
