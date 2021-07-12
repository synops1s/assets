$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.FSLogix.Unpack.log") -Force

Expand-Archive -Path ".\FSLogix.zip" -DestinationPath "$(Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "AppsRepositoryPath")\FSLogix" -Force -Verbose

Stop-Transcript
