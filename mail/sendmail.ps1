$SMTPServer = "smtp-mail.outlook.com"
$SMTPPort = "587"
$Credential = (Get-Credential)
$ToEmail = Read-Host -Prompt 'To mailaddress'
$Subject = Read-Host -Prompt 'Subject'
$Body = Read-Host -Prompt 'Body'

Send-MailMessage -From $Credential.UserName -To $ToEmail -SmtpServer $SMTPServer -Port $SMTPPort -Credential $Credential -UseSsl -Subject $Subject -body $Body