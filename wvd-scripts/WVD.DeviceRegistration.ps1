param(
    [String]$TenantId,
    [String]$TenantName
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.DeviceRegistration.log" -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -Value 1 -PropertyType DWord -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD"))
{
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Name "TenantId" -Value $TenantId -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Name "TenantName" -Value $TenantName -PropertyType String -Force -Verbose

Stop-Transcript
