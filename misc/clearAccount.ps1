$users = @("")
. .\addStandardGroups.ps1
ForEach ($user in $users) {
    if (Get-ADUser -Filter {samaccountname -eq $user}) {
        Write-Host "Clearing manager for $user"
        Set-ADUser -Identity $user -Clear Manager

        Write-Host "Disabling user $user"
        Disable-ADAccount -Identity $user

        Write-Host "Removing all $user groups"
        Get-ADUser -Identity $user -Properties MemberOf | ForEach-Object{
            $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
        }
        Add-StandardGroups -User $user
        $site = if (Assert-UserIsHagglunds -User $user) { "Hagglunds" } else { "Bofors" }
        Set-ADUser -Identity $user -clear 'telephoneNumber','homePhone', 'pager', 'mobile', 'facsimileTelephoneNumber', 'ipPhone'
        

        $account = Get-ADUser -Identity $user -Properties DistinguishedName, ObjectGUID
        $old_OU = $account | ForEach-Object {
            $_.DistinguishedName.Split(",")[1]
        }
        if ($site -eq "Hagglunds") {
            $new_OU = $old_OU + ",OU=Disabled accounts,OU=$site,OU=Companies,DC=net"
        }
        else {
            $new_OU = $old_OU + ",OU=Disabled Users,OU=$site,OU=Companies,DC=net"
        }
        Write-Host "Moving $user from $old_OU to $new_OU"
        Move-ADObject -Identity $account.ObjectGUID -TargetPath $new_OU
    }
    else {
        Write-Host "WARNING: User $user not found"
    }
}