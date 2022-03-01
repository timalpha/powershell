$httpListener = New-Object System.Net.HttpListener
$httpListener.Prefixes.Add('http://+:5001/')
$httpListener.Start()

$context = $httpListener.GetContext()

$context.Request.HttpMethod
$context.Request.Url
$context.Request.Headers.ToString() # pretty printing with .ToString()

# use a StreamReader to read the HTTP body as a string
$requestBodyReader = New-Object System.IO.StreamReader $context.Request.InputStream
$requestBodyReader.ReadToEnd()

$context.Response.StatusCode = 200
$context.Response.ContentType = 'text/html'

$responseFile = Get-Content("index.html")
$responseBytes = [System.Text.Encoding]::UTF8.GetBytes($responseFile)
$context.Response.OutputStream.Write($responseBytes, 0, $responseBytes.Length)

$context.Response.Close() # end the response

$httpListener.Close()