New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Apps.log" -Force

$AppsConfigFile = "X:\WVD.Apps.json"

$ErrorActionPreference = "Stop"

Function Get-WVDDecryptedKey
{
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $KeyName
    )

    Get-DecryptedKey -KeyValue (Get-ItemPropertyValue -Path "HKLM:SOFTWARE\Fujitsu\WVD" -Name $KeyName -ErrorAction Stop)
}

Function Get-DecryptedKey
{
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $KeyValue
    )

    ###### CSP Parameters #######
    $CspParameters = New-Object System.Security.Cryptography.CspParameters
    $CspParameters.KeyContainerName = "WVD.Crypto"
    $CspParameters.Flags = $CspParameters.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseMachineKeyStore
    $CspParameters.Flags = $CspParameters.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseNonExportableKey

    ####### Open Key from Machine CSP #######
    $RSA = [System.Security.Cryptography.RSACryptoServiceProvider]::new($CspParameters)

    ####### Decrypt #######
    $EncryptedBytes = [System.Convert]::FromBase64String($KeyValue)
    
    try {
        [System.Text.Encoding]::Unicode.GetString($RSA.Decrypt($EncryptedBytes, $true))
    }
    catch {}  
}

Write-Host -Message "ComputerName = $($env:COMPUTERNAME)"

$Credential = [PSCredential]::new((Get-WVDDecryptedKey -KeyName "FilePathAppsSecret1"), (ConvertTo-SecureString -AsPlainText -String (Get-WVDDecryptedKey -KeyName "FilePathAppsSecret2") -Force))

$FilePathApps = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Fujitsu\WVD" -Name "FilePathApps"

Remove-SmbMapping -RemotePath $FilePathApps -ErrorAction SilentlyContinue -Force
New-PSDrive -Name "X" -PSProvider FileSystem -Root $FilePathApps -Credential $Credential

If($false -eq (Test-Path -Path $AppsConfigFile)) {

    Write-Warning -Message "File '$($AppsConfigFile)' does not exist"
    return
}

$Apps = Get-Content -Path $AppsConfigFile -Raw | ConvertFrom-Json -AsHashtable
    
$HostPool = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\RDMonitoringAgent" -ErrorAction SilentlyContinue).SessionHostPool
    
If([System.String]::IsNullOrEmpty($HostPool)) {

    Write-Warning -Message "No host pool found in registry"
    return
}

If([System.String]::IsNullOrEmpty($Apps[$HostPool])) {

    Write-Warning -Message "No apps registered for Host Pool '$($HostPool)'"
    return
}

$Apps[$HostPool].Split(";") | ForEach-Object {
 
    $ApplicationName = $_

    $BasePath = "C:\WVD.Repository\WVD.Apps.$($ApplicationName)"
    $UnpackPath = Join-Path -Path $BasePath -ChildPath "Unpacked"
    $InstallPath = "C:\WVD.Apps\$($ApplicationName)"

    New-Item -Path $BasePath -ItemType Directory -Force

    Start-Transcript -Path (Join-Path -Path $BasePath -ChildPath "WVD.Apps.$($ApplicationName).Transcript.log") -Force

    Copy-Item -Path "X:\Packages\WVD.Apps.$($ApplicationName).*" -Destination $BasePath -ErrorAction Stop -Verbose
    
    Set-Location -Path $BasePath

    $ArchiveFilePath = Join-Path -Path $BasePath -ChildPath "WVD.Apps.$($ApplicationName).zip"
    if($true -eq (Test-Path -Path $ArchiveFilePath))
    {
        Expand-Archive -Path $ArchiveFilePath -DestinationPath (Join-Path -Path $BasePath -ChildPath "Unpacked") -Force -Verbose
    }

    $ScriptFilePath = Join-Path -Path $BasePath -ChildPath "WVD.Apps.$($ApplicationName).ps1"
    $ScriptFilePathOut = Join-Path -Path $BasePath -ChildPath "WVD.Apps.$($ApplicationName).log"
    $ScriptFilePathErrors = Join-Path -Path $BasePath -ChildPath "WVD.Apps.$($ApplicationName).RSE.log"

    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Unrestricted", "-File $($ScriptFilePath)", "-BasePath $($BasePath)", "-InstallPath $($InstallPath)", "-UnpackPath $($UnpackPath)" -RedirectStandardOutput $ScriptFilePathOut -RedirectStandardError $ScriptFilePathErrors -NoNewWindow -Wait -Verbose

    Stop-Transcript
}

Stop-Transcript
