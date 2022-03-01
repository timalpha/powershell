$wordfile = ".\english.txt"

function New-Passphrase() {

    $words = Get-Content $wordfile | Get-Random -Count 3

    $result = [string]::Format("{0} {1} {2}",$words)

    return $result

}

$pass = New-Passphrase

Write-Host $pass