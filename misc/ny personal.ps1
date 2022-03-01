. .\setUPN.ps1
. .\addStandardGroups.ps1
. .\password.ps1
$user = (Read-Host -Prompt "V-nummer").Trim()
$newPass = New-Password
$securePwd = ConvertTo-SecureString $newPass -AsPlainText -Force

Write-Host "Enabling user $user"
Enable-ADAccount -Identity $user

Write-Host "Setting new password $newPass for $user"
Set-ADAccountPassword -Identity $user -Reset -NewPassword $securePwd

Set-ADuserUPN -User $user

Add-StandardGroups -User $user

Set-ADUser -Identity $user -HomeDirectory "\\users\$user" -HomeDrive "H"
$paths = @("\\users\$user", "\\DM\$user")
ForEach($path in $paths) {
    if (Test-Path -Path $path) {
        Write-Host "$path already exist"
    }
    else {
        New-Item -Path $path -type directory
        $NewAcl = Get-Acl -Path $path


        $identity = "DOMAIN\$user"
        $rules = "Modify"
        $InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
        $PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
        $objType = [System.Security.AccessControl.AccessControlType]::Allow 

        $fileSystemAccessRuleArgumentList = $identity, $rules, $InheritanceFlag, $PropagationFlag, $objType
        $fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList

        $NewAcl.SetAccessRule($fileSystemAccessRule)
        Set-Acl -Path $path -AclObject $NewAcl
    }
}
