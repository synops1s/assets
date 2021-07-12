$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.Registration.log") -Force

$AgentFileName = "Microsoft.RDInfra.RDAgent.msi"
$BootloaderFileName = "Microsoft.RDInfra.RDAgentBootLoader.msi"

$RegistrationToken = Get-Content -Path "WVD.Registration.*.token"

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\RDInfraAgent") -eq $true)
{
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\RDInfraAgent" -Recurse -Verbose
}

Start-Process -FilePath "gpupdate.exe" -ArgumentList "/target:computer" -NoNewWindow -Wait
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $AgentFileName", "/quiet", "/qn", "/norestart", "/passive", "REGISTRATIONTOKEN=$RegistrationToken", "/l* $($LogPath)\WVD.Registration.Agent.log" -NoNewWindow -Wait -ErrorAction Continue -Verbose
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $BootloaderFileName", "/quiet", "/qn", "/norestart", "/passive", "/l* $($LogPath)\WVD.Registration.Bootloader.log" -NoNewWindow -Wait -ErrorAction Continue -Verbose

Restart-Service -Name "RDAgentBootLoader" -Force -Verbose

Stop-Transcript
