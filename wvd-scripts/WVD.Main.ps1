Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -Verbose
New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Main.log" -Force

Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.FSLogix.Unpack.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.FSLogix.Install.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.FSLogix.Config.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.OneDrive.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.Apps.Aquarius.Unpack.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.Apps.Aquarius.Install.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.Apps.Aquarius.Config.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.Registration.ps1" -NoNewWindow -Wait -Verbose 
Start-Process -FilePath "powershell.exe" -ArgumentList "-File WVD.AccessControlLists.ps1" -NoNewWindow -Wait -Verbose 

Stop-Transcript
