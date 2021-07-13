param(

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$HostPoolName,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$AESKey
)

Add-Type -AssemblyName System.Web

$HostPoolName = [System.Web.HttpUtility]::UrlDecode($HostPoolName)
$AESKey = [System.Web.HttpUtility]::UrlDecode($AESKey)

Function Invoke-Script {
    
    param(

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]$FileName,

        [Parameter(Mandatory=$False)]
        [String]$FilePath = (Get-Location).Path,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [String]$HostPoolName,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [String]$AESKey
    )

    $PSFilePath = Join-Path -Path $FilePath -ChildPath $FileName 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    if($True -eq [System.IO.File]::Exists($PSFilePath))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`" -FilePath `"$($FilePath)`" -HostPoolName `"$($HostPoolName)`" -AESKey `"$($AESKey)`"" -RedirectStandardError (Join-Path -Path $LogPath -ChildPath "$($PSFileName).RSE.log") -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

$LogPath = "C:\AVD\Logs"

New-Item -Path $LogPath -ItemType Directory -Force

Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Main.log") -Force

Set-TimeZone -Name "W. Europe Standard Time" -Verbose

If($false -eq (Test-Path -Path "HKLM:\SOFTWARE\AVD")) {

    New-Item -Path "HKLM:\SOFTWARE\AVD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath" -Value $LogPath -PropertyType "String" -Force -Verbose

Invoke-Script -FileName "AVD.Config.ps1" -HostPoolName $HostPoolName
Invoke-Script -FileName "AVD.ACL.ps1"
Invoke-Script -FileName "AVD.Defender.ps1"
Invoke-Script -FileName "AVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "AVD.FSLogix.Install.ps1"
Invoke-Script -FileName "AVD.FSLogix.Config.ps1"
Invoke-Script -FileName "AVD.DeviceRegistration.ps1"
Invoke-Script -FileName "AVD.Tasks.DeviceRegistration.ps1"
Invoke-Script -FileName "AVD.Tasks.Cleanup.ps1"
Invoke-Script -FileName "AVD.Registration.ps1"
Invoke-Script -FileName "AVD.Apps.ps1" -AESKey $AESKey

Start-ScheduledTask -TaskName "AVD-DeviceRegistration" -TaskPath "AVD" -Verbose
Start-ScheduledTask -TaskName "AVD-Cleanup" -TaskPath "AVD" -Verbose

Stop-Transcript
