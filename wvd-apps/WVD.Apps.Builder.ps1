$Apps = [ordered]@{}

$CurrentContext = Get-AzContext

$Contexts = Get-AzContext -ListAvailable | Select-Object -Property Name, Subscription, Tenant, Account | Sort-Object -Property Tenant, Subscription, Name, Account | Out-GridView -PassThru -Title "Select Subscription(s)"
$Contexts | Foreach-Object {
    
    $ContextName = $_.Name

    $Context = Get-AzContext -Name $ContextName 
    $Context | Select-AzContext | Out-Null

    Get-AzWvdHostPool | Select-Object Name | ForEach-Object {

        $Apps.Add($_.Name, "")
    }
}

Get-AzContext -Name $CurrentContext.Name | Select-AzContext | Out-Null

# $Apps | ConvertTo-Json | Out-File -FilePath ".\WVD.Apps.json"
# $Apps = Get-Content -Path ".\WVD.Apps.json" -Raw | ConvertFrom-Json -AsHashtable
