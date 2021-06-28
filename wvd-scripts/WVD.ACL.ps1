Start-Transcript -Path "C:\WVD\WVD.ACL.log" -Force

$ACL1 = [System.Security.AccessControl.FileSystemAccessRule]::new("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL2 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL3 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Users","ReadAndExecute, Synchronize","ContainerInherit, Objectinherit","None","Allow")

#region Set ACL Rules
$ACL = $null
$ACL = Get-Acl -Path "C:\Packages"
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$ACL = $null
$ACL = Get-Acl -Path "C:\WVD"
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$ACL = $null
$ACL = Get-Acl -Path "C:\WVD.Apps"
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL.AddAccessRule($ACL3)
$ACL | Set-Acl -Verbose

$ACL = $null
$ACL = Get-Acl -Path "C:\WVD.Repository"
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$ACL = $null
$ACL = Get-Acl -Path "C:\WindowsAzure"
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose
#endregion

Stop-Transcript
