#Requires -Version 3.0

#Local path
$FolderPath = '$[FOLDER]'

#Share name
$ShareName='$[SHARE_NAME]'

#Share description
$ShareDescription='$[SHARE_DESCRIPTION]'

#Create folder
New-Item -type directory -Path $FolderPath

#Create share rights
New-SmbShare -Name $ShareName -Path $FolderPath -ChangeAccess 'Authenticated Users' -Description $ShareDescription

#Get NTFS permissiongs
$Acl = Get-Acl $FolderPath

#Disable inheritance and clear permissions
$Acl.SetAccessRuleProtection($True, $False)

#Define NTFS rights
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Domain Admins','FullControl','ContainerInherit, ObjectInherit', 'None', 'Allow')
$Acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('SYSTEM','FullControl','ContainerInherit, ObjectInherit', 'None', 'Allow')
$Acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Authenticated Users",@("ReadData", "AppendData", "Synchronize"), "None", "None", "Allow")
$Acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('CREATOR OWNER','FullControl','ContainerInherit, ObjectInherit', 'InheritOnly', 'Allow')
$Acl.AddAccessRule($rule)

#Save ACL changes (NTFS permissions)
Set-Acl $FolderPath $Acl | Out-Null

#Show ACL so user can verify changes
Get-Acl $FolderPath  | Format-List