$ErrorActionPreference = "Stop"

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Tasks.DefenderUpdate.log") -Force

$Task = @"
Start-Transcript -Path "$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath"))\Tasks.DefenderUpdate.log" -Force

Update-MpSignature -Verbose

Stop-Transcript
"@

$Task | Set-Content -Path "$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "TaskSchedulerPath"))\AVD.Tasks.DefenderUpdate.ps1" -Force -Verbose

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "TaskSchedulerPath"))\AVD.Tasks.DefenderUpdate.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited

Register-ScheduledTask -TaskName "AVD-DefenderUpdate" -TaskPath "AVD" -Action $Action -Principal $Principal -Verbose

Stop-Transcript
