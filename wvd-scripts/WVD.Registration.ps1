New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Registration.log" -Force

$AgentFileName = "Microsoft.RDInfra.RDAgent.msi"
$BootloaderFileName = "Microsoft.RDInfra.RDAgentBootLoader.msi"

$RegistrationToken = Get-Content -Path "WVD.Registration.*.token"

Start-Process -FilePath "gpupdate.exe" -ArgumentList "/target:computer" -NoNewWindow -Wait
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $AgentFileName", "/quiet", "/qn", "/norestart", "/passive", "REGISTRATIONTOKEN=$RegistrationToken", "/l* C:\WVD\WVD.Registration.Agent.log" -NoNewWindow -Wait -ErrorAction Continue -Verbose
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $BootloaderFileName", "/quiet", "/qn", "/norestart", "/passive", "/l* C:\WVD\WVD.Registration.Bootloader.log" -NoNewWindow -Wait -ErrorAction Continue -Verbose

Stop-Transcript
