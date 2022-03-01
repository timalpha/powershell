Write-Host "Exportera grupper för en användare."
$user = Read-Host -Prompt "Användarnamn"
Get-ADPrincipalGroupMembership $user | Select-Object name | export-csv "grupper.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8
