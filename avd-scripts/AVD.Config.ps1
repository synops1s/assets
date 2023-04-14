param(

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$HostPoolName,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$LogPath,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$TaskSchedulerPath,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$AppsPath,

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$AppsRepositoryPath
)

$ErrorActionPreference = "Stop"

Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Config.log") -Force

$RegistryItemProperties = Get-Content -Path "$((Get-Location).Path)\AVD.RegistryItemProperties.json" | ConvertFrom-Json
$RegistryItemProperties = [System.Management.Automation.PSSerializer]::Deserialize([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RegistryItemProperties)))

$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "HostPoolName"; Value = $HostPoolName; PropertyType = "String"})
$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "LogPath"; Value = $LogPath; PropertyType = "String"})
$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "TaskSchedulerPath"; Value = $TaskSchedulerPath; PropertyType = "String"})
$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "AppsPath"; Value = $AppsPath; PropertyType = "String"})
$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "AppsPath"; Value = $AppsPath; PropertyType = "String"})
$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "AppsRepositoryPath"; Value = $AppsRepositoryPath; PropertyType = "String"})

$RegistryItemProperties | ForEach-Object {

    If($false -eq (Test-Path -Path $_.Path)) {

        New-Item -Path $_.Path -Force
    }

    New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.PropertyType -Force -Verbose
}

Stop-Transcript
