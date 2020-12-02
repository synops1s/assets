New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Apps.Aquarius.Install.log"

$BasePath = "C:\Packages\WVD.Apps.Aquarius"
$VCRedistFilePath = "$($BasePath)\vcredist_x64.exe"
$JavaSEFilePath = "$($BasePath)\jdk11.0.464.msi"

try {

    Start-Process -FilePath $VCRedistFilePath -ArgumentList "/install", "/quiet", "/norestart" -Wait -ErrorAction Stop
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $($JavaSEFilePath)", "/quiet", "/qb-!", "/norestart", "TRANSFORM=$($BasePath)\Oracle-JavaSEDevelopmentKit_11.0.4_x64_EN_1.1.1.mst", "/l* C:\WVD\WVD.Aquarius.JavaSE.log"  -Verbose | Wait-process
    $Result = [System.Environment]::ExitCode
}
catch {
    $Result = [System.Environment]::Exitcode
    [System.Environment]::Exit($Result)
}

[System.Environment]::Exit($Result)

Stop-Transcript
