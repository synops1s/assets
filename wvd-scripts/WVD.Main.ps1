param(
    [String]$SharePath,
    [String]$TenantId,
    [String]$TenantName,
    [String]$TenantDirectory,
    [String]$AESKey
)

Add-Type -AssemblyName System.Web

Function Invoke-Script {
    
    param(
        [String]$FileName,
        [String]$FilePath = (Get-Location).Path,
        [String]$SharePath,
        [String]$TenantId,
        [String]$TenantName,
        [String]$TenantDirectory,
        [String]$AESKey
    )

    New-Item -Path "C:\WVD" -ItemType Directory -Force
    New-Item -Path "C:\WindowsAzure" -ItemType Directory -Force

    $PSFilePath = Join-Path -Path $FilePath -ChildPath $FileName 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    if($True -eq [System.IO.File]::Exists($PSFilePath))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`" -FilePath `"$($FilePath)`" -SharePath `"$($SharePath)`" -TenantId `"$($TenantId)`" -TenantName `"$($TenantName)`" -TenantDirectory `"$($TenantDirectory)`" -AESKey `"$($AESKey)`"" -RedirectStandardError "C:\WVD\$($PSFileName).RSE.log" -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Main.log" -Force

Invoke-Script -FileName "WVD.Config.ps1" -SharePath $SharePath -TenantId $TenantId -TenantName $TenantName -TenantDirectory $TenantDirectory
Invoke-Script -FileName "WVD.ACL.ps1"
Invoke-Script -FileName "WVD.Defender.ps1" -SharePath $SharePath
Invoke-Script -FileName "WVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "WVD.FSLogix.Install.ps1"
Invoke-Script -FileName "WVD.FSLogix.Config.ps1" -SharePath $SharePath
Invoke-Script -FileName "WVD.SSO.ps1"
Invoke-Script -FileName "WVD.SSO.Office.ps1" -TenantId $TenantId
Invoke-Script -FileName "WVD.DeviceRegistration.ps1" -TenantId $TenantId -TenantName $TenantName
Invoke-Script -FileName "WVD.Tasks.DeviceRegistration.ps1"
Invoke-Script -FileName "WVD.Tasks.Cleanup.ps1"
Invoke-Script -FileName "WVD.Registration.ps1"
Invoke-Script -FileName "WVD.Apps.ps1" -AESKey ([System.Web.HttpUtility]::UrlDecode($AESKey))

Set-TimeZone -Name "W. Europe Standard Time" -Verbose

Start-ScheduledTask -TaskName "WVD-DeviceRegistration" -TaskPath "WVD" -Verbose
Start-ScheduledTask -TaskName "WVD-Cleanup" -TaskPath "WVD" -Verbose

Stop-Transcript
