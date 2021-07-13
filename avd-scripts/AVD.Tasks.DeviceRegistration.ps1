$ErrorActionPreference = "Stop"

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Tasks.DeviceRegistration.log") -Force

$Task = @"
Start-Transcript -Path "$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath"))\Tasks.DeviceRegistration.log" -Force

Start-Process -FilePath "$($env:SystemRoot)\System32\dsregcmd.exe" -ArgumentList "/join", "/debug" -NoNewWindow -Wait

Stop-Transcript
"@

$Task | Set-Content -Path "$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "TaskSchedulerPath"))\AVD.Tasks.DeviceRegistration.ps1" -Force -Verbose

Get-ScheduledTask -TaskName "AVD-DeviceRegistration" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -Verbose

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "TaskSchedulerPath"))\AVD.Tasks.DeviceRegistration.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited

$Trigger1 = New-ScheduledTaskTrigger -Once -At ([System.DateTime]::Now.AddMinutes(5)) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Minutes 10)
$Trigger2 = New-ScheduledTaskTrigger -AtStartup

$Trigger = @($Trigger1, $Trigger2)

Register-ScheduledTask -TaskName "AVD-DeviceRegistration" -TaskPath "AVD" -Action $Action -Trigger $Trigger -Principal $Principal -Verbose

Stop-Transcript
