Start-Transcript -Path "C:\WVD\WVD.Initialize.log"

$ACL1 = [System.Security.AccessControl.FileSystemAccessRule]::new("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL2 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators","FullControl","ContainerInherit, Objectinherit","None","Allow")

#region Set ACL Rules
$ACLPackages = Get-Acl -Path "C:\Packages"
$ACLPackages.Access | ForEach-Object { $ACLPackages.RemoveAccessRule($_) }
$ACLPackages.SetAccessRuleProtection($true, $false)
$ACLPackages.AddAccessRule($ACL1)
$ACLPackages.AddAccessRule($ACL2)
$ACLPackages | Set-Acl

$ACLWVD = Get-Acl -Path "C:\WVD"
$ACLWVD.Access | ForEach-Object { $ACLWVD.RemoveAccessRule($_) }
$ACLWVD.SetAccessRuleProtection($true, $false)
$ACLWVD.AddAccessRule($ACL1)
$ACLWVD.AddAccessRule($ACL2)
$ACLWVD | Set-Acl
#endregion

Stop-Transcript
