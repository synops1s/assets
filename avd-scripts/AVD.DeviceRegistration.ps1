$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.DeviceRegistration.log") -Force

### Just trigger the Automatic-Device-Join task which will set the (userCertificate) Attribute in AD (Which allows AAD Connect Filter to sync device to AAD) ###

Start-Process -FilePath "$($env:SystemRoot)\System32\dsregcmd.exe" -ArgumentList "/join", "/debug" -NoNewWindow -Wait

Stop-Transcript
