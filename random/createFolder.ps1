function createNewRemoteFolder($newFolderPath) {

    $scriptStr = "New-Item -Path $newFolderPath -type directory -Force"
    $scriptBlock = [scriptblock]::Create($scriptStr)

    runScriptBlock $scriptBlock
}

function runScriptBlock($scriptBlock) {

    Invoke-Command -ComputerName $server -Credential $creds -ScriptBlock $scriptBlock
}