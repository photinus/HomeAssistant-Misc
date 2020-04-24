## Long Lived Access Token
$llt = "InserLLAT-HERE"
## Home Assistant Base URL (include trailing slash)
$url = "http://192.168.1.100:8123/"
## IP or Hostname of your Home Assistant Server (check for reachability)
$haIP = "192.168.1.100"
## Sensor Name (all lower case)
$sensorName = "videoconferencingactive"
$sensorFriendlyName = "Bobs Video Conferencing Active"


Function Test-ConnectionQuietFast {
 
    [CmdletBinding()]
    param(
    [String]$ComputerName,
    [int]$Count = 1,
    [int]$Delay = 500
    )
 
    for($I = 1; $I -lt $Count + 1 ; $i++)
    {
        Write-Verbose "Ping Computer: $ComputerName, $I try with delay $Delay milliseconds"
 
        # Test the connection quiet to the computer with one ping
        If (Test-Connection -ComputerName $ComputerName -Quiet -Count 1)
        {
            # Computer can be contacted, return $True
            Write-Verbose "Computer: $ComputerName is alive! With $I ping tries and a delay of $Delay milliseconds"
            return $True
        }
 
        # delay between each pings
        Start-Sleep -Milliseconds $Delay
    }
 
    # Computer cannot be contacted, return $False
    Write-Verbose "Computer: $ComputerName cannot be contacted! With $Count ping tries and a delay of $Delay milliseconds"
    $False
}

$url = "$($url)api/states/binary_sensor.$($sensorName)"

if(Test-ConnectionQuietFast $haIP -count 1)
{

    $bjn = (Get-NetUDPEndpoint -OwningProcess (Get-Process -Name BlueJeans).Id -ErrorAction SilentlyContinue | measure).count
    $teams = (Get-NetUDPEndpoint -OwningProcess (Get-Process -Name Teams).Id -ErrorAction SilentlyContinue | measure).count
    $zoom = (Get-NetUDPEndpoint -OwningProcess (Get-Process -Name Zoom).Id -ErrorAction SilentlyContinue | measure).count

    if($bjn -gt 8)
    {
        $vState = 'on'
    } else {
        $vState = 'off'
    }
    if($teams -gt 2)
    {
        $vState = 'on'
    }
    if($teams -gt 0)
    {
        $vState = 'on'
    }

    $headers = @{
        'Authorization' = "Bearer $llt"
        'Content-Type' = 'application/json'
    }

    $attribs = @{
        'friendly_name' = $sensorFriendlyName
    }

    $body = @{
        state=$vState
        attributes=$attribs
    }
    $json = $body | ConvertTo-Json

    invoke-restmethod $url -headers $headers -body $json -method 'POST'
}
