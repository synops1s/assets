$BasePath = "C:\WVD.Unpack"

$Scripts = @(
    "WVD.Apps.Aquarius.Unpack.ps1"
    "WVD.Apps.Aquarius.Install.ps1"
    "WVD.Apps.Aquarius.Config.ps1"
)

$Scripts | Foreach-Object {

    $FilePath = Join-Path -Path $BasePath -ChildPath $_
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Unrestricted", "-File $($FilePath)" -RedirectStandardError "C:\WVD\$($FilePath).RSE.log" -Wait -Verbose
}
