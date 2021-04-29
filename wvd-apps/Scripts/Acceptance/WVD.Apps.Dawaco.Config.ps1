New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Apps.Dawaco.Config.log" -Force

$BasePath = "C:\WVD.Apps\Dawaco"
New-Item -Path $BasePath -ItemType Directory -ErrorAction SilentlyContinue -Force

#region Dawaco Ana
$CmdDawacoAna = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\dawana.exe"
exit
"@
$CmdDawacoAna | Set-Content -Path "$($BasePath)\Dawaco.Ana.cmd" -Force -Verbose
#endregion

#region Dawaco Art Exp
$CmdDawacoArtExp = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawArt_Exp.exe"
exit
"@
$CmdDawacoArtExp | Set-Content -Path "$($BasePath)\Dawaco.Art.Exp.cmd" -Force -Verbose
#endregion

#region Dawaco Art Imp
$CmdDawacoArtImp = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawArt_Imp.exe"
exit
"@
$CmdDawacoArtImp | Set-Content -Path "$($BasePath)\Dawaco.Art.Imp.cmd" -Force -Verbose
#endregion

#region Dawaco Mnb
$CmdDawacoMnb = @"
@echo off
start "" "\\pwnkaadawacofs.file.core.windows.net\dawaco\Programs\DawMnb.exe"
exit
"@
$CmdDawacoMnb | Set-Content -Path "$($BasePath)\Dawaco.Mnb.cmd" -Force -Verbose
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

Stop-Transcript
