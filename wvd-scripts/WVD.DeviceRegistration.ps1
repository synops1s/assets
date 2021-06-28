param(
    [String]$TenantId,
    [String]$TenantName
)

Start-Transcript -Path "C:\WVD\WVD.DeviceRegistration.log" -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -Value 1 -PropertyType DWord -Force -Verbose

if($False -eq (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD"))
{
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Name "TenantId" -Value $TenantId -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDJ\AAD" -Name "TenantName" -Value $TenantName -PropertyType String -Force -Verbose

### Just trigger the Automatic-Device-Join task which will set the (userCertificate) Attribute in AD (Which allows AAD Connect Filter to sync device to AAD) ###
Start-Process -FilePath "$($env:SystemRoot)\System32\dsregcmd.exe" -ArgumentList "/join", "/debug" -NoNewWindow -Wait

Stop-Transcript
