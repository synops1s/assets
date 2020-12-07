Function Invoke-Script {
    
    param(
        [String]$FileName,
        [String]$BasePath
    )

    New-Item -Path "C:\WVD" -ItemType Directory -Force
    $FilePath = Join-Path -Path $BasePath -ChildPath $FileName 
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Unrestricted", "-File $($FilePath).ps1" -RedirectStandardError "C:\WVD\$($FilePath).RSE.log" -Wait -Verbose
}


New-Item -Path "C:\WVD" -ItemType Directory -Force

Start-Transcript -Path "C:\WVD\WVD.Main.log" -Force

Invoke-Script -FileName "WVD.FSLogix.Unpack" -BasePath "."
Invoke-Script -FileName "WVD.FSLogix.Install" -BasePath "."
Invoke-Script -FileName "WVD.FSLogix.Config" -BasePath "."
Invoke-Script -FileName "WVD.OneDrive" -BasePath "."
Invoke-Script -FileName "WVD.AccessControlLists" -BasePath "."
Invoke-Script -FileName "WVD.Registration" -BasePath "."

Invoke-Script -FileName "WVD.Apps.Aquarius.Unpack" -BasePath "."
Invoke-Script -FileName "WVD.Apps.Aquarius.Install" -BasePath "."
Invoke-Script -FileName "WVD.Apps.Aquarius.Config" -BasePath "."

Stop-Transcript
