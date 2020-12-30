param(
    [String]$BasePath
)

Function Invoke-Script {
    
    param(
        [String]$FilePath,
        [String]$BasePath
    )

    New-Item -Path "C:\WVD" -ItemType Directory -Force

    $PSFilePath = Join-Path -Path $BasePath -ChildPath $FilePath 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File $($PSFilePath) -BasePath $($BasePath)" -RedirectStandardError "C:\WVD\$($PSFileName).RSE.log" -Wait -Verbose
}

New-Item -Path "C:\WVD" -ItemType Directory -Force

Start-Transcript -Path "C:\WVD\WVD.Main.log" -Force

Invoke-Script -FileName "WVD.FSLogix.Unpack" -BasePath "."
Invoke-Script -FileName "WVD.FSLogix.Install" -BasePath "."
Invoke-Script -FileName "WVD.FSLogix.Config" -BasePath "."
Invoke-Script -FileName "WVD.Registration" -BasePath "."

Invoke-Script -FilePath "WVD.Apps.ps1" -BasePath $BasePath

Stop-Transcript
