param(
    [String]$AESKey
)

Start-Transcript -Path "C:\WVD\WVD.Apps.log" -Force

$AppsConfigFile = "X:\WVD.Apps.json"

$ErrorActionPreference = "Stop"

Function Get-WVDAESIVFromRegistry
{
    param (
        [Parameter(Mandatory=$false)]
        [String]
        $Path = "HKLM:\SOFTWARE\WVD\Configuration",

        [Parameter(Mandatory=$false)]
        [String]
        $Name = "IV"
    )

    $AESIV = Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop
    [System.Convert]::FromBase64String($AESIV)
}

Function Unprotect-WVDAESString {

    param (

        [Parameter(Mandatory=$true, ParameterSetName = "EncryptedBytes")]
        [Parameter(ParameterSetName = "Base64")]
        [ValidateNotNull()]
        [System.Security.Cryptography.AesCryptoServiceProvider]
        $AesCryptoServiceProvider,

        [Parameter(Mandatory=$false, ParameterSetName = "EncryptedBytes")]
        [ValidateNotNull()]
        [System.Byte[]]
        $EncryptedBytes,

        [Parameter(Mandatory=$true, ParameterSetName = "Base64")]
        [ValidateNotNullOrEmpty()]
        [System.String]
        $Base64String,

        [Parameter(Mandatory=$true, ParameterSetName = "Base64")]
        [switch]
        $FromBase64
    )

    $Decryptor = $AesCryptoServiceProvider.CreateDecryptor()

    If($FromBase64.IsPresent) {

        $EB = [System.Convert]::FromBase64String($Base64String)
        $UB = $Decryptor.TransformFinalBlock($EB, 0, $EB.Length)
        
    }
    else {
        
        $UB = $Decryptor.TransformFinalBlock($EncryptedBytes, 0, $EncryptedBytes.Length)
    }

    [System.Text.Encoding]::UTF8.GetString($UB)
}

Function Unprotect-WVDSecret
{
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [System.Security.Cryptography.AesCryptoServiceProvider]
        $AesCryptoServiceProvider,

        [Parameter(Mandatory=$false)]
        [String]
        $Path = "HKLM:\SOFTWARE\WVD\Configuration",

        [Parameter(Mandatory=$true)]
        [String]
        $Name
    )

    Unprotect-WVDAESString -AesCryptoServiceProvider $AesCryptoServiceProvider -Base64String (Get-ItemPropertyValue -Path $Path -Name $Name -ErrorAction Stop) -FromBase64
}

Write-Host -Message "ComputerName = $($env:COMPUTERNAME)"

$AESKeyDS = [System.Management.Automation.PSSerializer]::Deserialize([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($AESKey)))

$AES = [System.Security.Cryptography.AesCryptoServiceProvider]::new()

$AES.Key = $AESKeyDS
$AES.IV = Get-WVDAESIVFromRegistry

$Credential = [PSCredential]::new((Unprotect-WVDSecret -AesCryptoServiceProvider $AES -Name "FilePathAppsSecret1"), (ConvertTo-SecureString -AsPlainText -String (Unprotect-WVDSecret -AesCryptoServiceProvider $AES -Name "FilePathAppsSecret2") -Force))

$FilePathApps = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "FilePathApps"

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
