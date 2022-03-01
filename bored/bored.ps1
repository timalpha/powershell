$response = Invoke-RestMethod -Uri http://www.boredapi.com/api/activity/
Write-Output $response.activity