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

$VCRedistFilePath = Join-Path -Path $UnpackPath -ChildPath "vcredist_x64.exe"
$JavaSEFilePath = Join-Path -Path $UnpackPath -ChildPath "jdk11.0.464.msi"
$TransformFilePath = Join-Path -Path $UnpackPath -ChildPath "Oracle-JavaSEDevelopmentKit_11.0.4_x64_EN_1.1.1.mst"

try {

    Start-Process -FilePath $VCRedistFilePath -ArgumentList "/install", "/quiet", "/norestart" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $($JavaSEFilePath)", "/quiet", "/qb-!", "/norestart", "TRANSFORM=$($TransformFilePath)", "/l* $($JavaSEFilePath).log" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    
    $Result = [System.Environment]::ExitCode
}
catch {
    $Result = [System.Environment]::Exitcode
}

$Result

#region Aquarius
$CmdAquarius = @"
@echo off
IF EXIST "C:\Program Files\Java\jdk-11.0.4\bin\java.exe" (
    set JAVA_HOME=C:\Program Files\Java\jdk-11.0.4
)

\\PNWNLOTA079\aquarius_519\sw_runtime\Aquarius.cmd
"@
$CmdAquarius | Set-Content -Path "$($InstallPath)\Aquarius.cmd" -Force -Verbose
#endregion

#region Emacs
$CmdEmacs = @"
@echo off
\\PNWNLOTA079\aquarius_519\sw_runtime\Aquarius_emacs.cmd
"@
$CmdEmacs | Set-Content -Path "$($InstallPath)\Emacs.cmd" -Force -Verbose
#endregion
