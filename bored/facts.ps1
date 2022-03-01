$response =  Invoke-RestMethod -Uri https://asli-fun-fact-api.herokuapp.com/
Write-Output $response.data.fact