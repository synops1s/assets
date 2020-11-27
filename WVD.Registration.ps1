Start-Transcript -Path "C:\WVD\WVD.Registration.log"

$AgentFileName = "Microsoft.RDInfra.RDAgent.msi"
$BootloaderFileName = "Microsoft.RDInfra.RDAgentBootLoader.msi"

$RegistrationToken = Get-Content -Path "WVD.Registration.*.token"

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $AgentFileName", "/quiet", "/qn", "/norestart", "/passive", "REGISTRATIONTOKEN=$RegistrationToken", "/l* C:\WVD\WVD.Provisioning.Agent.log" -Verbose | Wait-process
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $BootloaderFileName", "/quiet", "/qn", "/norestart", "/passive", "/l* C:\WVD\WVD.Provisioning.Bootloader.log"  -Verbose | Wait-process

Stop-Transcript
