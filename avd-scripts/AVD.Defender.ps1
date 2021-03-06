$ErrorActionPreference = "Stop"

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Defender.log") -Force

$FSLogixUNCPath = Join-Path -Path "\\$((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "ProfilePrimaryEndPoint"))" -ChildPath (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "ProfileShareName") -Verbose

$ExclusionPaths = @(
    $FSLogixUNCPath
    "C:\ProgramData\FSLogix\Proxy"
    "C:\ProgramData\FSLogix\Cache"
    "C:\Program Files\FSLogix"
    "C:\Windows\Temp"
    "*\frxdrv.sys"
    "*\frxdrvvt.sys"
    "*\frxccd.sys"
)

$ExclusionExtensions = @(
    ".vhd"
    ".vhdx"
)

$ExclusionProcesses = @(
    "frxccd.exe"
    "frxccds.exe"
    "frxsvc.exe"
)

Add-MpPreference -ExclusionPath $ExclusionPaths -Verbose
Add-MpPreference -ExclusionExtension $ExclusionExtensions -Verbose
Add-MpPreference -ExclusionProcess $ExclusionProcesses -Verbose

# Get-MpPreference | Select-Object -Property ExclusionExtension, ExclusionIpAddress, ExclusionPath, ExclusionProcess | ConvertTo-Json

Stop-Transcript
