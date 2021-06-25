param(
    [String]$RSAParameters
)

New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.RSA.log" -Force

If($null -eq $RSAParameters) {

    Write-Warning -Message "No RSA Parameters provided" -ErrorAction Continue
}
else {

    ###### CSP Parameters #######

    $CspParameters = New-Object System.Security.Cryptography.CspParameters
    
    $CspParameters.KeyContainerName = "WVD.RSA"
    $CspParameters.Flags = $CspParameters.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseMachineKeyStore
    $CspParameters.Flags = $CspParameters.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseNonExportableKey

    $RSA = [System.Security.Cryptography.RSACryptoServiceProvider]::new($CspParameters)
    
    $RSA.ImportParameters([System.Management.Automation.PSSerializer]::Deserialize([Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($RSAParameters))))
    $RSA.PersistKeyInCsp = $true
    
    $RSA.Clear()
}

Stop-Transcript
