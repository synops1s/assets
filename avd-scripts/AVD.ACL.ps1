$LogPath = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "LogPath")
Start-Transcript -Path (Join-Path -Path $LogPath -ChildPath "WVD.ACL.log") -Force

$ACL1 = [System.Security.AccessControl.FileSystemAccessRule]::new("NT AUTHORITY\SYSTEM","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL2 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Administrators","FullControl","ContainerInherit, Objectinherit","None","Allow")
$ACL3 = [System.Security.AccessControl.FileSystemAccessRule]::new("BUILTIN\Users","ReadAndExecute, Synchronize","ContainerInherit, Objectinherit","None","Allow")

#region Set ACL Rules
$Path = "C:\Packages"
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$Path = $LogPath
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$Path = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "TaskSchedulerPath")
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$Path = "C:\WindowsAzure"
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$Path = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "AppsRepositoryPath")
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL | Set-Acl -Verbose

$Path = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\WVD" -Name "AppsInstallPath")
New-Item -Path $Path -ItemType Directory -Force
$ACL = $null
$ACL = Get-Acl -Path $Path
$ACL.Access | ForEach-Object { $ACL.RemoveAccessRule($_) }
$ACL.SetAccessRuleProtection($true, $false)
$ACL.AddAccessRule($ACL1)
$ACL.AddAccessRule($ACL2)
$ACL.AddAccessRule($ACL3)
$ACL | Set-Acl -Verbose
#endregion

Stop-Transcript
