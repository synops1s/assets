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

    if($True -eq [System.IO.File]::Exists($PSFilePath))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File $($PSFilePath) -BasePath $($BasePath)" -RedirectStandardError "C:\WVD\$($PSFileName).RSE.log" -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

New-Item -Path "C:\WVD" -ItemType Directory -Force

Start-Transcript -Path "C:\WVD\WVD.Apps.log" -Force

# Invoke-Script -FilePath "Scripts\WVD.AccessControlLists" -BasePath $BasePath

Invoke-Script -FilePath "Scripts\WVD.OneDrive.ps1" -BasePath $BasePath

Invoke-Script -FilePath "Scripts\WVD.Apps.Aquarius.Unpack.ps1" -BasePath $BasePath
Invoke-Script -FilePath "Scripts\WVD.Apps.Aquarius.Install.ps1" -BasePath $BasePath
Invoke-Script -FilePath "Scripts\WVD.Apps.Aquarius.Config.ps1" -BasePath $BasePath

Stop-Transcript
