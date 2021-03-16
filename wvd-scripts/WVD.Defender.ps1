param(
    [String]$SharePath
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Defender.log" -Force

$FSLogixUNCPath = Join-Path -Path $SharePath -ChildPath "fslogixprofiles" -Verbose
# $FSLogixUNCPath = "\\pwnkapweprdwvdsaprofile.file.core.windows.net\fslogixprofiles"

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
