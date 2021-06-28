param(
    [String]$SharePath,
    [String]$TenantId,
    [String]$TenantName,
    [String]$TenantDirectory
)

Start-Transcript -Path "C:\WVD\WVD.Config.log" -Force

New-Item -Path "C:\WVD.Apps" -ItemType Directory -Force
New-Item -Path "C:\WVD.Repository" -ItemType Directory -Force

$FSLogixUNCPath = Join-Path -Path $SharePath -ChildPath "fslogixprofiles" -Verbose
$MSIXAppAttachUNCPath = Join-Path -Path $SharePath -ChildPath "msixappattach" -Verbose
$AppsUNCPath = Join-Path -Path $SharePath -ChildPath "apps" -Verbose

If($false -eq (Test-Path -Path "HKLM:\SOFTWARE\WVD")) {

    New-Item -Path "HKLM:\SOFTWARE\WVD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "MajorVersion" -Value 2 -PropertyType DWord -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "MinorVersion" -Value 0 -PropertyType DWord -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "TenantId" -Value $TenantId -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "TenantName" -Value $TenantName -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "TenantDirectory" -Value $TenantDirectory -PropertyType String -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "FilePathFSLogixProfiles" -Value $FSLogixUNCPath -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "FilePathMSIX" -Value $MSIXAppAttachUNCPath -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "FilePathApps" -Value $AppsUNCPath -PropertyType String -Force -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\WVD" -Name "DomainUserGroup" -Value "DLG_SEC_WVD_Users" -PropertyType String -Force -Verbose

# Max Disconnection Time: 4 hours
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration" -Name "MaxDisconnectionTime" -Value 14400000 -PropertyType DWord -Force -Verbose
# Max Idle Time: 4 hours
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration" -Name "MaxIdleTime" -Value 14400000 -PropertyType DWord -Force -Verbose

Stop-Transcript
