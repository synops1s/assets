param(
    [String]$BasePath = "."
)

Function Invoke-Script {
    
    param(
        [String]$FilePath,
        [String]$BasePath
    )

    New-Item -Path "C:\WVD" -ItemType Directory -Force

    $PSFilePath = Join-Path -Path $BasePath -ChildPath $FilePath 
    $PSFileName = [System.IO.Path]::GetFileNameWithoutExtension($PSFilePath)

    Write-Host $PSFilePath

    if($True -eq [System.IO.File]::Exists($PSFileName))
    {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass", "-File $($PSFilePath) -BasePath $($BasePath)" -RedirectStandardError "C:\WVD\$($PSFileName).RSE.log" -Wait -Verbose
    }
    else
    {
        Write-Information "File '$($PSFilePath)' does not exists"
    }
}

New-Item -Path "C:\WVD" -ItemType Directory -Force

Start-Transcript -Path "C:\WVD\WVD.Main.log" -Force

Invoke-Script -FileName "WVD.FSLogix.Unpack.ps1"
Invoke-Script -FileName "WVD.FSLogix.Install.ps1"
Invoke-Script -FileName "WVD.FSLogix.Config.ps1"
Invoke-Script -FileName "WVD.Registration.ps1"

Invoke-Script -FilePath "WVD.Apps.ps1" -BasePath $BasePath

Stop-Transcript
