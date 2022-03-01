$department = Read-Host "Enter department"
$group = Read-Host "Enter group"
$users = Get-ADUser -Filter "Department -like '$department*'" | Select-Object -ExpandProperty SamAccountName
ForEach ($user in $users) {
    if (Get-ADuser -Identity $user | Where-Object {$_.Enabled -eq $true}) {
        Write-Host "Lägger till $user i $group"
        Add-ADGroupMember -Identity $group -Members $user
    }
    else {
        Write-Host "Tar bort inaktiv $user från $group"
        Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    }
}