function Add-StandardGroups {
    param (
        [Parameter(Mandatory)]
        [string]$User
    )
    if (Get-ADUser -Filter {samaccountname -eq $user}) {
        $ovik = @(
            "grupp1"
            "grupp2")
        $bofors = @(
            "grupp1"
            "grupp2")

        $groups = if (Assert-UserIsHagglunds -user $user) {$ovik} else {$bofors}
        ForEach ($group in $groups) {
            Write-Host "Adding $user to group $group"
            Add-ADGroupMember -Identity $group -Members $user
        }
    }
}
function Assert-UserIsHagglunds {
    param (
        [Parameter(Mandatory)]
        [string]$user
    )
    if ($user -match "v[0-9][0-9][0-9][0-9][0-9]") {return $true} else { return $false}
}
function Assert-UserExists {
    Param(
        [Parameter(Mandatory)]
        [String]$User
    )
    [bool](Get-ADUser -Filter {samaccountname -eq $user})
}
function IsValidEmail { 
    param([string]$EmailAddress)

    try {
        $null = [mailaddress]$EmailAddress
        return $true
    }
    catch {
        return $false
    }
}