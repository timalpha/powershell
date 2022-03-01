$wordfile = ".\english.txt"

function New-Password() {

    $words = Get-Content $wordfile | Get-Random -Count 2
    $words = [string]::Format("{0}-{1}",$words)
    $pass = (Get-Culture).TextInfo.ToTitleCase($words)
    $result = $pass + (-join ((35..38) | Get-Random -Count 1 | ForEach-Object {[char]$_})) + (-join ((48..57) | Get-Random -Count 2 | ForEach-Object {[char]$_}))
    if ($result.length -lt 14) {
        New-Password
        break
    }
    return $result

}

$pass = New-Password

Write-Host $pass
