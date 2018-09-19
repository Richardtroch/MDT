param (
        # Drive Letter i.e E:
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $DriveLetter,

        [Parameter(ValueFromPipelineByPropertyName)]
        [system.String] $MDTProductionName = 'MDTProduction',

        [Parameter(ValueFromPipelineByPropertyName)]
        [system.String] $MDTReferenceName = 'MDTReference'

)

Function Create-MDTShare {

       param (
        # Folder Path
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $Path,

        # share Name
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $ShareName


         )

         Begin {

            ## Create Folder
            If (!(Test-Path $Path)) {$result = New-Item -Path $Path -ItemType Directory}
            Write-Verbose -Message ('Created Directory ''{0}''.' -f $Path)

            $result = New-SmbShare -Name $ShareName -Path $Path -ChangeAccess EVERYONE
            Write-Verbose -Message ('Created Share ''{0}''.' -f $ShareName)

         }


}

Function Create-MDTUser {

       param (
        # User Name
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $User,

        # Password
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        $Password


         )

         Begin {

            #$Password = Read-Host -AsSecureString -Prompt "Enter password for local MDT User"
            #$Password = ConvertTo-SecureString -AsPlainText "$Password" -Force
            $result = New-LocalUser -Name $User -PasswordNeverExpires -AccountNeverExpires -Password $Password -ErrorAction Stop

            Write-Verbose -Message ('Created Local User ''{0}''.' -f $User)

         }


}

Function Set-MDTPermissions {

       param (
        # User Name
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $User,

        # Path
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [system.String] $Path


         )

         Begin {

            $acl = Get-Acl $Path
            $permission = $User, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow"
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $Path

            Write-Verbose -Message ('Set Permissions on ''{0}''.' -f $Path)

         }


}

## Create local MDT User
Create-MDTUser -User MDTConnect -Password (Read-Host -AsSecureString -Prompt 'Please enter password for local MDT user')

## Create MDT Shares
Create-MDTShare -Path "$DriveLetter\$MDTReferenceName" -ShareName "$MDTReferenceName$"
Create-MDTShare -Path "$DriveLetter\$MDTProductionName" -ShareName "$MDTProductionName$"

## Set NTFS Permissions for Reference Share
Set-MDTPermissions -User MDTConnect -Path "$DriveLetter\$MDTReferenceName\Captures"
Set-MDTPermissions -User MDTConnect -Path "$DriveLetter\$MDTReferenceName\Logs"

## Set NTFS Permisions
Set-MDTPermissions -User MDTConnect -Path "$DriveLetter\$MDTProductionName\Captures"
Set-MDTPermissions -User MDTConnect -Path "$DriveLetter\$MDTProductionName\Logs"
