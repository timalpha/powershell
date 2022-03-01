. .\password.ps1
. .\addStandardGroups.ps1

$firstname = (Read-Host -Prompt "F�rnamn").Trim()
$surname = (Read-Host -Prompt "Efternamn").Trim()
$name = "$surname $firstname"
Write-Host $name
$search = Get-ADUser -Filter {Name -eq $name} -SearchBase "OU=Users,DC=net" | Measure-Object
if ($search.Count -ne 0) {
    Write-Host "A user with name $name already exists"
    Exit
}
$email = (Read-Host -Prompt "E-mail").Trim()
do {
    try {
        [ValidatePattern('\+\d{7,}')]$mobile = (Read-Host -Prompt "Mobilnummer").Trim()
    }
    catch {}
} until ($?)
$company = Read-Host -Prompt "F�retag"
do {
    try {
        [ValidatePattern('tlc[0-9][0-9][0-9][0-9]')]$tlcID = (Read-Host -Prompt "TLC ID").Trim()
    }
    catch {}
} until ($?)
$newPass = New-Password
$securePwd = ConvertTo-SecureString $newPass -AsPlainText -Force
$props = @{
    SamAccountName = $tlcID
    UserPrincipalName = "$tlcID@net"
    AccountPassword = $securePwd
    Enabled = $true
    PasswordNeverExpires = $true
    CannotChangePassword= $true
    Title = "Extern TLC User"
    Department = "OIP"
    Manager = ""
    Path = "OU=Users,DC=net"
    EmailAddress = $email
    MobilePhone = $mobile
    GivenName = $firstname
    Surname = $surname
    Name = $name
    DisplayName = $name
    Company = $company
}
$groups = @(
    "grupp1"
    "grupp2"
)
if (Assert-UserExists -User $tlcID) {
    Write-Host "User with $tlcid already exists"
    
}
else {
    Write-Host "Skapar $tlcID med l�senord $newPass"
    New-ADUser @props -ErrorAction Stop
    ForEach ($group in $groups) {
        Write-Host "Adding $tlcID to group $group"
        Add-ADGroupMember -Identity $group -Members $tlcID
    }
}
