New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.FSLogix.Install.log"

try {
    
    $ArgumentList = "/install", "/quiet", "/norestart"
    Start-Process -FilePath "C:\Packages\FSLogix\x64\Release\FSLogixAppsSetup.exe" -ArgumentList $ArgumentList -Wait -ErrorAction Stop
    $Result = [System.Environment]::ExitCode
}
catch {
    $Result = [System.Environment]::Exitcode
    [System.Environment]::Exit($Result)
}

[System.Environment]::Exit($Result)

Stop-Transcript
