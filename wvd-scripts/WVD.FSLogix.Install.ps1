$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.FSLogix.Install.log") -Force

$BasePath = "$(Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "AppsRepositoryPath")\FSLogix"
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
