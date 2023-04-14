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

    $PSFilePath = Join-Path -Path $FilePath -ChildPath $FileName 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    if($true -eq [System.IO.File]::Exists($PSFilePath))
    {
        if($null -ne $Parameters) {

            $ParameterString = [System.Text.StringBuilder]::new()
            $Parameters.GetEnumerator() | ForEach-Object {

                $ParameterString.Append("-$($_.Name) `"$($_.Value)`" ")
            }

            Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`"", "$($ParameterString)" -RedirectStandardError (Join-Path -Path $LogPath -ChildPath "$($PSFileName).RSE.log") -Wait -Verbose
        }
        else {
            
            Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File `"$($PSFilePath)`"" -RedirectStandardError (Join-Path -Path $LogPath -ChildPath "$($PSFileName).RSE.log") -Wait -Verbose
        }
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

$LogPath = "C:\AVD.Logs"
$TaskSchedulerPath = "C:\AVD.Tasks"
$AppsPath = "C:\AVD.Apps"
$AppsRepositoryPath = "C:\AVD.Repository"

New-Item -Path $LogPath -ItemType Directory -Force
New-Item -Path $TaskSchedulerPath -ItemType Directory -Force
New-Item -Path $AppsPath -ItemType Directory -Force
New-Item -Path $AppsRepositoryPath -ItemType Directory -Force

Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Main.log") -Force

Add-Type -AssemblyName System.Web

$HostPoolName = [System.Web.HttpUtility]::UrlDecode($HostPoolName)
$AESKey = [System.Web.HttpUtility]::UrlDecode($AESKey)

Set-TimeZone -Name "W. Europe Standard Time" -Verbose

Invoke-Script -FileName "AVD.Config.ps1" -Parameters @{ HostPoolName = $HostPoolName; LogPath = $LogPath; TaskSchedulerPath = $TaskSchedulerPath; AppsPath = $AppsPath; AppsRepositoryPath = $AppsRepositoryPath }
Invoke-Script -FileName "AVD.ACL.ps1"
Invoke-Script -FileName "AVD.Defender.ps1"
Invoke-Script -FileName "AVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "AVD.FSLogix.Install.ps1"
Invoke-Script -FileName "AVD.FSLogix.Config.ps1"
Invoke-Script -FileName "AVD.Tasks.ps1"
Invoke-Script -FileName "AVD.DeviceRegistration.ps1"
Invoke-Script -FileName "AVD.Apps.ps1" -Parameters @{ AESKey = $AESKey }
Invoke-Script -FileName "AVD.Registration.ps1"

Start-ScheduledTask -TaskName "AVD-DeviceRegistration" -TaskPath "AVD" -Verbose
Start-ScheduledTask -TaskName "AVD-Cleanup" -TaskPath "AVD" -Verbose

Stop-Transcript
