param (
    [Parameter(Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $BasePath,

    [Parameter(Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $InstallPath,
    
    [Parameter(Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $UnpackPath
)

New-Item -Path $InstallPath -ItemType Directory -ErrorAction SilentlyContinue -Force -Verbose

$CopyFiles = @(
    "Codejock.CommandBars.Unicode.v17.3.0.ocx"
    "Codejock.ReportControl.Unicode.v17.3.0.ocx"
    "Codejock.SkinFramework.Unicode.v17.3.0.ocx"
    "Visual Report Writer 2011 Developer Edition API.ocx"
)

$CopyFiles | ForEach-Object {
    
    Copy-Item -Path (Join-Path -Path $UnpackPath -ChildPath $_) -Destination (Join-Path -Path $InstallPath -ChildPath $_) -Verbose
}

#Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s", "`"$($FilePath)`"" -NoNewWindow -Wait -ErrorAction Continue -Verbose

# try {

#     Start-Process -FilePath $VCRedistFilePath -ArgumentList "/install", "/quiet", "/norestart" -NoNewWindow -Wait -ErrorAction Continue -Verbose
#     Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $($JavaSEFilePath)", "/quiet", "/qb-!", "/norestart", "TRANSFORM=$($TransformFilePath)", "/l* $($JavaSEFilePath).log" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    
#     $Result = [System.Environment]::ExitCode
# }
# catch {
#     $Result = [System.Environment]::Exitcode
# }

# $Result

#region Dawaco Ana
$CmdDawacoAna = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\dawana.exe"
exit
"@
$CmdDawacoAna | Set-Content -Path "$($InstallPath)\Dawaco.Ana.cmd" -Force -Verbose
#endregion

#region Dawaco Art Exp
$CmdDawacoArtExp = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawArt_Exp.exe"
exit
"@
$CmdDawacoArtExp | Set-Content -Path "$($InstallPath)\Dawaco.Art.Exp.cmd" -Force -Verbose
#endregion

#region Dawaco Art Imp
$CmdDawacoArtImp = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawArt_Imp.exe"
exit
"@
$CmdDawacoArtImp | Set-Content -Path "$($InstallPath)\Dawaco.Art.Imp.cmd" -Force -Verbose
#endregion

#region Dawaco Mnb
$CmdDawacoMnb = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawMnb.exe"
exit
"@
$CmdDawacoMnb | Set-Content -Path "$($InstallPath)\Dawaco.Mnb.cmd" -Force -Verbose
#endregion

if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide" -force -ErrorAction SilentlyContinue }
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex" -force -ErrorAction SilentlyContinue }
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0" -force -ErrorAction SilentlyContinue }
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Defaults") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Defaults" -force -ErrorAction SilentlyContinue }
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\WinPrint") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\WinPrint" -force -ErrorAction SilentlyContinue }
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Workspaces") -ne $true) {  New-Item "HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Workspaces" -force -ErrorAction SilentlyContinue }

New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0' -Name 'CurrentVersion' -Value '19.0.30.8' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0' -Name 'CurrentVersionDescription' -Value 'DataFlex 2017 Windows Client 19.0' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0' -Name 'Installed Language' -Value 'English' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Defaults' -Name 'DFPath' -Value '.;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Bin;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Usr;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Lib;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Bitmaps;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Help' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Defaults' -Name 'VDFRootDir' -Value '\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Defaults' -Name 'dbAdminMode' -Value 'OFF' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\WinPrint' -Name 'RegName' -Value 'To be used with DataFlex' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\WinPrint' -Name 'BitmapPath' -Value '\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Bitmaps' -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\WOW6432Node\Data Access Worldwide\DataFlex\19.0\Workspaces' -Name 'SystemDFPath' -Value '.;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Bin;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Usr;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Lib;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Bitmaps;\\pwnkaadawacofs.file.core.windows.net\dawaco\DF19\Help' -PropertyType String -Force -ErrorAction SilentlyContinue
