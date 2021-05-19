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

$FTAFilePath = (Join-Path -Path $InstallPath -ChildPath "SetUserFTA.exe")

Copy-Item -Path (Join-Path -Path $UnpackPath -ChildPath "SetUserFTA.exe") -Destination $FTAFilePath -Verbose

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FTA.PDF" -Value "$($FTAFilePath) .pdf AcroExch.Document.DC" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FTA.WLL" -Value "$($FTAFilePath) .wll Applications\notepad.exe" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FTA.XLK" -Value "$($FTAFilePath) .xlk Applications\notepad.exe" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FTA.XLL" -Value "$($FTAFilePath) .xll Applications\notepad.exe" -PropertyType String -Force -Verbose

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "FTA.PDF" -Value "$($FTAFilePath) .pdf AcroExch.Document.DC" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "FTA.WLL" -Value "$($FTAFilePath) .wll Applications\notepad.exe" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "FTA.XLK" -Value "$($FTAFilePath) .xlk Applications\notepad.exe" -PropertyType String -Force -Verbose
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RailRunonce" -Name "FTA.XLL" -Value "$($FTAFilePath) .xll Applications\notepad.exe" -PropertyType String -Force -Verbose
