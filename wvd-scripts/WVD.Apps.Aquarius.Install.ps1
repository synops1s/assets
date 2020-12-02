Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -Verbose
New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Apps.Aquarius.Install.log" -Force

$BasePath = "C:\Packages\WVD.Apps.Aquarius"
$VCRedistFilePath = "$($BasePath)\vcredist_x64.exe"
$JavaSEFilePath = "$($BasePath)\jdk11.0.464.msi"

try {

    Start-Process -FilePath $VCRedistFilePath -ArgumentList "/install", "/quiet", "/norestart" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $($JavaSEFilePath)", "/quiet", "/qb-!", "/norestart", "TRANSFORM=$($BasePath)\Oracle-JavaSEDevelopmentKit_11.0.4_x64_EN_1.1.1.mst", "/l* C:\WVD\WVD.Apps.Aquarius.JavaSE.log" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    
    $Result = [System.Environment]::ExitCode
}
catch {
    $Result = [System.Environment]::Exitcode
    [System.Environment]::Exit($Result)
}

[System.Environment]::Exit($Result)

Stop-Transcript
