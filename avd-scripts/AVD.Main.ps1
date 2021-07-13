param(

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$HostPoolName,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$AESKey
)

Function Invoke-Script {
    
    param(

        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]$FileName,

        [Parameter(Mandatory=$False)]
        [ValidateNotNull()]
        [Hashtable]$Parameters,

        [Parameter(Mandatory=$False)]
        [String]$FilePath = (Get-Location).Path
    )

    $ParameterString = [System.Text.StringBuilder]::new()

    $Parameters.GetEnumerator() | ForEach-Object {

        $ParameterString.Append("-$($_.Name) `"$($_.Value)`" ")
    }

    $PSFilePath = Join-Path -Path $FilePath -ChildPath $FileName 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    if($True -eq [System.IO.File]::Exists($PSFilePath))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`"", "$($ParameterString)" -RedirectStandardError (Join-Path -Path $LogPath -ChildPath "$($PSFileName).RSE.log") -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

$LogPath = "C:\AVD\Logs"

New-Item -Path $LogPath -ItemType Directory -Force

Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Main.log") -Force

If($false -eq (Test-Path -Path "HKLM:\SOFTWARE\AVD")) {

    New-Item -Path "HKLM:\SOFTWARE\AVD" -Force
}

New-ItemProperty -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath" -Value $LogPath -PropertyType "String" -Force -Verbose

#######

Add-Type -AssemblyName System.Web

$HostPoolName = [System.Web.HttpUtility]::UrlDecode($HostPoolName)
$AESKey = [System.Web.HttpUtility]::UrlDecode($AESKey)

Set-TimeZone -Name "W. Europe Standard Time" -Verbose

Invoke-Script -FileName "AVD.Config.ps1" -Parameters @{ HostPoolName = $HostPoolName }
Invoke-Script -FileName "AVD.ACL.ps1"
Invoke-Script -FileName "AVD.Defender.ps1"
Invoke-Script -FileName "AVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "AVD.FSLogix.Install.ps1"
Invoke-Script -FileName "AVD.FSLogix.Config.ps1"
Invoke-Script -FileName "AVD.DeviceRegistration.ps1"
Invoke-Script -FileName "AVD.Tasks.DeviceRegistration.ps1"
Invoke-Script -FileName "AVD.Tasks.Cleanup.ps1"
Invoke-Script -FileName "AVD.Registration.ps1"
Invoke-Script -FileName "AVD.Apps.ps1" -Parameters @{ AESKey = $AESKey }

Start-ScheduledTask -TaskName "AVD-DeviceRegistration" -TaskPath "AVD" -Verbose
Start-ScheduledTask -TaskName "AVD-Cleanup" -TaskPath "AVD" -Verbose

Stop-Transcript
