$name = (Read-Host -Prompt "Gruppnamn").Trim()
$groups = @((-join ($name, "_c")), (-join ($name, "_r")))
do {
    try {
        [ValidatePattern('\\\\')]$path = (Read-Host -Prompt "Sökväg [\\..]").Trim()
    }
    catch {}
} until ($?)
foreach ($group in $groups) {
    $search = Get-ADGroup -Filter {Name -eq $group} -SearchBase "OU=Groups,DC=net" | Measure-Object
    if ($search.Count -ne 0) {
        Write-Host "A group with name $group already exists"
        Exit
    }
    if ($group[-1] -eq 'c') {
        $description = "Ger läs- och skrivrättighet till $path"
    }
    else {
        $description = "Ger läsrättighet till $path"
    }
    $props = @{
        Name = $group
        DisplayName = $group
        SamAccountName = $group
        Description = $description
        Path = "OU=Groups,DC=net"
        GroupCategory = "Security"
        GroupScope = "Global"
    }
    New-ADGroup @props
}