function Get-SanitizedUTF8Input{
    Param(
        [Parameter(Mandatory)]
        [String]$Text
    )
    $replaceTable = @{"�"="ss";"�"="a";"�"="a";"�"="a";"�"="a";"�"="a";"�"="a";"�"="ae";"�"="c";"�"="e";"�"="e";"�"="e";"�"="e";"�"="i";"�"="i";"�"="i";"�"="i";"�"="d";"�"="n";"�"="o";"�"="o";"�"="o";"�"="o";"�"="o";"�"="o";"�"="u";"�"="u";"�"="u";"�"="u";"�"="y";"�"="p";"�"="y"}

    foreach($key in $replaceTable.Keys){
        $Text = $Text -Replace($key,$replaceTable.$key)
    }
    $Text = $Text -replace '[^a-zA-Z0-9]', ''
    return $Text
}
function Set-ADuserUPN {
    Param(
        [Parameter(Mandatory)]
        [String]$user
    )
    if ($aduser = Get-ADUser -Identity $user) {
        $firstname = Get-SanitizedUTF8Input -Text $aduser.GivenName.ToLower()
        $surname = Get-SanitizedUTF8Input -Text $aduser.Surname.ToLower()
        $fullname = "$firstname.$surname"
        Write-Host $fullname
        $domain = "localhost"
        $UPN = "$fullname@$domain"
        Write-Host $UPN
        Set-Aduser -Identity $user -UserPrincipalName $UPN
    }
}
