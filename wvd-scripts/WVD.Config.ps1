param(
    [String]$RegistryItemProperties
)

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.Config.log") -Force

$RegistryItemProperties = [System.Management.Automation.PSSerializer]::Deserialize([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RegistryItemProperties)))

$RegistryItemProperties | ForEach-Object {

    If($false -eq (Test-Path -Path $_.Path)) {

        New-Item -Path $_.Path -Force
    }

    New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.PropertyType -Force -Verbose
}

Stop-Transcript
