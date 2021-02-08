New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.ACL.log" -Force

$ACL1 = [System.Security.AccessControl.FileSystemAccessRule]::new("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL2 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators","FullControl","ContainerInherit, Objectinherit","None","Allow")

#region Set ACL Rules
$ACLPackages = Get-Acl -Path "C:\Packages"
$ACLPackages.Access | ForEach-Object { $ACLPackages.RemoveAccessRule($_) }
$ACLPackages.SetAccessRuleProtection($true, $false)
$ACLPackages.AddAccessRule($ACL1)
$ACLPackages.AddAccessRule($ACL2)
$ACLPackages | Set-Acl -Verbose

$ACLWVD = Get-Acl -Path "C:\WVD"
$ACLWVD.Access | ForEach-Object { $ACLWVD.RemoveAccessRule($_) }
$ACLWVD.SetAccessRuleProtection($true, $false)
$ACLWVD.AddAccessRule($ACL1)
$ACLWVD.AddAccessRule($ACL2)
$ACLWVD | Set-Acl -Verbose
#endregion

Stop-Transcript
