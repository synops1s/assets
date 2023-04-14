$LogPath = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath" -ErrorAction Stop
$AppsPath = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "AppsPath" -ErrorAction Stop
$TaskSchedulerPath = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "TaskSchedulerPath" -ErrorAction Stop

$ImagesPath = Join-Path -Path $AppsPath -ChildPath "Images"
$MountsPath = Join-Path -Path $AppsPath -ChildPath "Mounts"

$DefenderUpdateTask = [PSCustomObject]@{
    
    TaskName = "DefenderUpdate"
    Script = @"
        Start-Transcript -Path "$($LogPath)\Tasks.{{TaskName}}.log" -Force

        Update-MpSignature -Verbose

        Stop-Transcript
"@
    Trigger = @((New-ScheduledTaskTrigger -Daily -At 7am))
    Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited
}

$DeviceRegistrationTask = [PSCustomObject]@{
    
    TaskName = "DeviceRegistration"
    Script = @"
        Start-Transcript -Path "$($LogPath)\Tasks.{{TaskName}}.log" -Force

        Start-Process -FilePath "$($env:SystemRoot)\System32\dsregcmd.exe" -ArgumentList "/join", "/debug" -NoNewWindow -Wait

        Stop-Transcript
"@
    Trigger = @((New-ScheduledTaskTrigger -Once -At ([System.DateTime]::Now.AddMinutes(5)) -RepetitionDuration (New-TimeSpan -Days 1) -RepetitionInterval (New-TimeSpan -Minutes 10)), (New-ScheduledTaskTrigger -AtStartup))
    Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited
}

$CleanupTask = [PSCustomObject]@{
    
    TaskName = "Cleanup"
    Script = @"
        Start-Transcript -Path "$($LogPath)\Tasks.{{TaskName}}.log" -Force

        Start-Sleep -Seconds 30 -Verbose

        Remove-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Downloads\*" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\*\*.log" -Recurse -ErrorAction SilentlyContinue

        Get-Item -Path "C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\*\Status\*" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 | Remove-Item

        Remove-Item -Path "C:\Packages\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\Downloads\*" -Recurse -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\WindowsAzure\Logs\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\*.log" -Recurse -ErrorAction SilentlyContinue

        Get-Item -Path "C:\Packages\Plugins\Microsoft.CPlat.Core.RunCommandWindows\*\Status\*" -ErrorAction SilentlyContinue | Sort-Object -Property LastWriteTime | Select-Object -SkipLast 1 | Remove-Item

        Stop-Transcript
"@
    Trigger = @()
    Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited
}

$MountImagesTask = [PSCustomObject]@{
    
    TaskName = "MountImages"
    Script = @"
        Start-Transcript -Path "$($LogPath)\Tasks.{{TaskName}}.log" -Force

        `$Images = Get-ChildItem -Path "$($ImagesPath)" -Filter "*.vhdx"
        `$Images | ForEach-Object {
            
            `$ApplicationName = `$_.Name.Split(".")[2]
            `$ImageDestinationFilePath = Join-Path -Path "$($ImagesPath)" -ChildPath "AVD.Apps.`$(`$ApplicationName).vhdx"
            `$MountFilePath = "$($MountsPath)\`$(`$ApplicationName)"
        
            `$Disk = Get-DiskImage -ImagePath `$ImageDestinationFilePath
        
            if(`$Disk.Number) {
        
                `$Partition = Get-Partition -DiskNumber `$Disk.Number | Where-Object { `$_.Type -eq "Basic" }
        
                `$Partition.AccessPaths | ForEach-Object {
        
                    `$Partition | Remove-PartitionAccessPath -AccessPath `$_ -ErrorAction SilentlyContinue
                }
            }
        
            if(`$true -eq (Get-VHD -Path `$ImageDestinationFilePath).Attached) {
        
                Dismount-VHD -Path `$ImageDestinationFilePath -ErrorAction SilentlyContinue
            }
        
            Remove-Item -Path `$MountFilePath -ErrorAction SilentlyContinue -Force -Verbose
        }

        `$Images | ForEach-Object {
            
            `$ApplicationName = `$_.Name.Split(".")[2]
            `$ImageDestinationFilePath = Join-Path -Path "$($ImagesPath)" -ChildPath "AVD.Apps.`$(`$ApplicationName).vhdx"
            `$MountFilePath = "$($MountsPath)\`$(`$ApplicationName)"
        
            New-Item -Path `$MountFilePath -ItemType Directory -ErrorAction SilentlyContinue -Force -Verbose
        
            if(`$false -eq (Get-VHD -Path `$ImageDestinationFilePath).Attached) {
            
                Mount-VHD -Path `$ImageDestinationFilePath -NoDriveLetter
            }
        
            `$Disk = Get-DiskImage -ImagePath `$ImageDestinationFilePath
            
            if(`$null -ne `$Disk) {
        
                `$Partition = Get-Partition -DiskNumber `$Disk.Number | Where-Object { `$_.Type -eq "Basic" }
                    
                if(`$false -eq `$Partition.AccessPaths.Contains("`$(`$MountFilePath)\")) {
        
                    Add-PartitionAccessPath -DiskNumber `$Disk.Number -PartitionNumber `$Partition.PartitionNumber -AccessPath `$MountFilePath -Verbose
                }
            }
        }

        Stop-Transcript
"@
    Trigger = @(New-ScheduledTaskTrigger -AtStartup)
    Principal = New-ScheduledTaskPrincipal -GroupId "SYSTEM" -RunLevel Limited
}

$Tasks = @(
    $DefenderUpdateTask
    $DeviceRegistrationTask
    $CleanupTask
    $MountImagesTask
)

$Tasks | ForEach-Object {

    $ErrorActionPreference = "Stop"
    
    $_.Script = $_.Script.Replace("{{TaskName}}", $_.TaskName)

    Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Tasks.$($_.TaskName).log") -Force

    $ScriptFilePath = "$($TaskSchedulerPath)\AVD.Tasks.$($_.TaskName).ps1"
    $_.Script | Set-Content -Path $ScriptFilePath -Force -Verbose
    $Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -File $($ScriptFilePath)"
    
    if($_.Trigger.Count -eq 0) {

        Register-ScheduledTask -TaskName "AVD-$($_.TaskName)" -TaskPath "AVD" -Action $Action -Principal $_.Principal -Verbose
    } else {

        Register-ScheduledTask -TaskName "AVD-$($_.TaskName)" -TaskPath "AVD" -Trigger $_.Trigger -Action $Action -Principal $_.Principal -Verbose
    }

    Stop-Transcript
}
