Start-Transcript -Path "C:\WVD\WVD.Tasks.Cleanup.log" -Force

$Task = @"
Start-Transcript -Path "C:\WVD\Tasks\WVD.Tasks.Cleanup.log" -Force

Start-Sleep -Seconds 30 -Verbose

Remove-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Downloads\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\*\*.log" -Recurse -ErrorAction SilentlyContinue

Get-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Status\*" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 | Remove-Item

Stop-Transcript
"@

New-Item -Path "C:\WVD\Tasks" -ItemType Directory -Force
$Task | Set-Content -Path "C:\WVD\Tasks\WVD.Tasks.Cleanup.ps1" -Force -Verbose

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\WVD\Tasks\WVD.Tasks.Cleanup.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited

Register-ScheduledTask -TaskName "WVD-Cleanup" -TaskPath "WVD" -Action $Action -Principal $Principal -Verbose

Stop-Transcript
