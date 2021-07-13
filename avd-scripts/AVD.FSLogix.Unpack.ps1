$ErrorActionPreference = "Stop"

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.FSLogix.Unpack.log") -Force

Expand-Archive -Path "$((Get-Location).Path)\FSLogix.zip" -DestinationPath "$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "AppsRepositoryPath"))\FSLogix" -Force -Verbose

Stop-Transcript
