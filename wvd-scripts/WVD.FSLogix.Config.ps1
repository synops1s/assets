Start-Transcript -Path "C:\WVD\WVD.FSLogix.Config.log"

$FSLogixUNCPath = "\\pwnkaaweaccwvdsaprofile.file.core.windows.net\fslogixprofiles"

# Microsoft Defender Exclusion for FSLogix
Add-MpPreference -ExclusionPath $FSLogixUNCPath

# Add FSLogix Settings
New-Item -Path HKLM:\Software\FSLogix\ -Name Profiles -Force
New-Item -Path HKLM:\Software\FSLogix\Profiles\ -Name Apps -Force

Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "Enabled" -Type "Dword" -Value "1"
New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "VHDLocations" -Value $FSLogixUNCPath -PropertyType MultiString -Force

Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "SizeInMBs" -Type "Dword" -Value "32768"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "IsDynamic" -Type "Dword" -Value "1"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "VolumeType" -Type "Dword" -Value "vhd"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "LockedRetryCount" -Type "Dword" -Value "12"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "LockedRetryInterval" -Type "Dword" -Value "5"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "ProfileType" -Type "Dword" -Value "3"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "ConcurrentUserSessions" -Type "Dword" -Value "1"
Set-ItemProperty -Path HKLM:\Software\FSLogix\Profiles -Name "RoamSearch" -Type "Dword" -Value "2" 

New-ItemProperty -Path HKLM:\Software\FSLogix\Profiles\Apps -Name "RoamSearch" -Type "Dword" -Value "2"

Stop-Transcript
