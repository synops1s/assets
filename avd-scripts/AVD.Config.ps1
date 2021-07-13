param(

    [Parameter(Mandatory=$True)]
    [ValidateNotNullOrEmpty()]
    [String]$HostPoolName
)

$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\AVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "AVD.Config.log") -Force

$RegistryItemProperties = Get-Content -Path ".\AVD.RegistryItemProperties.json" | ConvertFrom-Json
$RegistryItemProperties = [System.Management.Automation.PSSerializer]::Deserialize([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RegistryItemProperties)))

$RegistryItemProperties.Add([pscustomobject]@{Path = "HKLM:\SOFTWARE\AVD"; Name = "HostPoolName"; Value = $HostPoolName; PropertyType = "String"})

$RegistryItemProperties | ForEach-Object {

    If($false -eq (Test-Path -Path $_.Path)) {

        New-Item -Path $_.Path -Force
    }

    New-ItemProperty -Path $_.Path -Name $_.Name -Value $_.Value -PropertyType $_.PropertyType -Force -Verbose
}

Stop-Transcript
