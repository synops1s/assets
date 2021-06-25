param(
    [String]$SharePath,
    [String]$TenantId,
    [String]$TenantName,
    [String]$TenantDirectory
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Config.log" -Force

$FSLogixUNCPath = Join-Path -Path $SharePath -ChildPath "fslogixprofiles" -Verbose
$MSIXAppAttachUNCPath = Join-Path -Path $SharePath -ChildPath "msixappattach" -Verbose
$AppsUNCPath = Join-Path -Path $SharePath -ChildPath "apps" -Verbose

If($false -eq (Test-Path -Path "HKLM:\SOFTWARE\Fujitsu\WVD")) {

    New-Item -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "MajorVersion" -Value 2 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "MinorVersion" -Value 0 -PropertyType DWord -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "TenantId" -Value $TenantId -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "TenantName" -Value $TenantName -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "TenantDirectory" -Value $TenantDirectory -PropertyType String -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "FilePathFSLogixProfiles" -Value $FSLogixUNCPath -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "FilePathMSIX" -Value $MSIXAppAttachUNCPath -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "FilePathApps" -Value $AppsUNCPath -PropertyType String -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "DomainUserGroup" -Value "DLG_SEC_WVD_Users" -PropertyType String -Force -Verbose

# Max Disconnection Time: 4 hours
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration" -Name "MaxDisconnectionTime" -Value 14400000 -PropertyType DWord -Force -Verbose
# Max Idle Time: 4 hours
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration" -Name "MaxIdleTime" -Value 14400000 -PropertyType DWord -Force -Verbose

Stop-Transcript
