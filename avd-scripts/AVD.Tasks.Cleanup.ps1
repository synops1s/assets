$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.Tasks.Cleanup.log") -Force

$Task = @"
Start-Transcript -Path "$(Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")\Tasks.Cleanup.log" -Force

Start-Sleep -Seconds 30 -Verbose

Remove-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Downloads\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\*\*.log" -Recurse -ErrorAction SilentlyContinue

Get-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Status\*" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 | Remove-Item

Remove-Item -Path "C:\Packages\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\Downloads\*" -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\*.log" -Recurse -ErrorAction SilentlyContinue

Get-Item -Path "C:\Packages\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\Status\*" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 | Remove-Item

Stop-Transcript
"@

$Task | Set-Content -Path "$(Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "TaskSchedulerPath")\WVD.Tasks.Cleanup.ps1" -Force -Verbose

$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File $(Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "TaskSchedulerPath")\WVD.Tasks.Cleanup.ps1"
$Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited

Register-ScheduledTask -TaskName "WVD-Cleanup" -TaskPath "WVD" -Action $Action -Principal $Principal -Verbose

Stop-Transcript
