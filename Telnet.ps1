$protocol = "SSH"
$port = 22
$ips = Get-Content "C:\Users\test\Desktop\ipsnetwork.txt"
$jobs = foreach ($ip in $ips) {
    Write-Host "Testing $ip"
    Start-Job -ScriptBlock {
        param($ip, $protocol, $port)
        $result = Test-NetConnection -ComputerName $ip -Port $port -InformationLevel Quiet
        if ($result -eq "True") {
            Write-Host "$ip is OPEN on port $port using $protocol" -ForegroundColor Green
        } else {
            Write-Host "$ip is NOT OPEN on port $port using $protocol" -ForegroundColor Red
        }
    } -ArgumentList $ip, $protocol, $port
}
$results = $jobs | Wait-Job | Receive-Job
