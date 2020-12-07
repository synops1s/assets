New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.FSLogix.Install.log" -Force

$BasePath = "C:\Packages\FSLogix"
$FSLogixFilePath = "$($BasePath)\x64\Release\FSLogixAppsSetup.exe"

try {

    Start-Process -FilePath $FSLogixFilePath -ArgumentList "/install", "/quiet", "/norestart" -NoNewWindow -Wait -ErrorAction Continue -Verbose
    
    $Result = [System.Environment]::ExitCode
}
catch {
    $Result = [System.Environment]::Exitcode
    [System.Environment]::Exit($Result)
}

[System.Environment]::Exit($Result)

Stop-Transcript
