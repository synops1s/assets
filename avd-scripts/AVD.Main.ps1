param(
    [String]$RegistryItemProperties,
    [String]$AESKey
)

Add-Type -AssemblyName System.Web

$RegistryItemProperties =[System.Web.HttpUtility]::UrlDecode($RegistryItemProperties)
$AESKey =[System.Web.HttpUtility]::UrlDecode($AESKey)

Function Invoke-Script {
    
    param(
        [String]$FileName,
        [String]$FilePath = (Get-Location).Path,
        [String]$RegistryItemProperties,
        [String]$AESKey
    )

    $PSFilePath = Join-Path -Path $FilePath -ChildPath $FileName 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    if($True -eq [System.IO.File]::Exists($PSFilePath))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`" -FilePath `"$($FilePath)`" -RegistryItemProperties `"$($RegistryItemProperties)`" -AESKey `"$($AESKey)`"" -RedirectStandardError (Join-Path -Path $LogPath -ChildPath "$($PSFileName).RSE.log") -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")

New-Item -Path $LogPath -ItemType Directory -Force

Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.Main.log") -Force

Set-TimeZone -Name "W. Europe Standard Time" -Verbose

Invoke-Script -FileName "WVD.Config.ps1" -RegistryItemProperties $RegistryItemProperties
Invoke-Script -FileName "WVD.ACL.ps1"
Invoke-Script -FileName "WVD.Defender.ps1"
Invoke-Script -FileName "WVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "WVD.FSLogix.Install.ps1"
Invoke-Script -FileName "WVD.FSLogix.Config.ps1"
Invoke-Script -FileName "WVD.DeviceRegistration.ps1"
Invoke-Script -FileName "WVD.Tasks.DeviceRegistration.ps1"
Invoke-Script -FileName "WVD.Tasks.Cleanup.ps1"
Invoke-Script -FileName "WVD.Registration.ps1"
Invoke-Script -FileName "WVD.Apps.ps1" -AESKey $AESKey

Start-ScheduledTask -TaskName "WVD-DeviceRegistration" -TaskPath "WVD" -Verbose
Start-ScheduledTask -TaskName "WVD-Cleanup" -TaskPath "WVD" -Verbose

Stop-Transcript
