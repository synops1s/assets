New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Main.log"

Start-Process -NoNewWindow powershell '-File WVD.Initialize.ps1' -Verbose -Wait
Start-Process -NoNewWindow powershell '-File WVD.FSLogix.Unpack.ps1' -Verbose -Wait
Start-Process -NoNewWindow powershell '-File WVD.FSLogix.Install.ps1' -Verbose -Wait
Start-Process -NoNewWindow powershell '-File WVD.OneDrive.ps1' -Verbose -Wait
Start-Process -NoNewWindow powershell '-File WVD.Registration.ps1' -Verbose -Wait

Stop-Transcript
