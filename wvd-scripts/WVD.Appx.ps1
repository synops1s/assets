$AllowedAppxPackages = @(
    "Microsoft.AccountsControl"
    "Windows.PrintDialog"
    "Microsoft.MSPaint"
    "Microsoft.WindowsCalculator"
    "Microsoft.AAD.BrokerPlugin"
    "Microsoft.Windows.Search"
    "Microsoft.VCLibs.140.00.UWPDesktop"
    "Microsoft.NET.Native.Framework.2.2"
    "Microsoft.NET.Native.Runtime.2.2"
    "Microsoft.MicrosoftEdge"
    "Microsoft.VCLibs.140.00"
)

Get-AppxPackage | ForEach-Object {if($False -eq $AllowedAppxPackages.Contains($_.Name)) { Remove-AppxPackage -Package $_ } }
