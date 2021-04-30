Start-Transcript -Path "C:\WVD\WVD.Tasks.DeviceRegistration.log" -Force

$Task = @"
Start-Transcript -Path "C:\WVD\Tasks\WVD.Tasks.DeviceRegistration.log" -Force

Start-Process -FilePath "$($env:SystemRoot)\System32\dsregcmd.exe" -ArgumentList "/join", "/debug" -NoNewWindow -Wait

Stop-Transcript
"@

New-Item -Path "C:\WVD\Tasks" -ItemType Directory -Force
$Task | Set-Content -Path "C:\WVD\Tasks\WVD.Tasks.DeviceRegistration.ps1" -Force -Verbose

Get-ScheduledTask -TaskName "WVD-DeviceRegistration" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$false -Verbose

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\WVD\Tasks\WVD.Tasks.DeviceRegistration.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited

$Trigger1 = New-ScheduledTaskTrigger -Once -At ([System.DateTime]::Now.AddMinutes(5)) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Minutes 10)
$Trigger2 = New-ScheduledTaskTrigger -AtStartup

$Trigger = @($Trigger1, $Trigger2)

Register-ScheduledTask -TaskName "WVD-DeviceRegistration" -TaskPath "WVD" -Action $Action -Trigger $Trigger -Principal $Principal -Verbose

Stop-Transcript