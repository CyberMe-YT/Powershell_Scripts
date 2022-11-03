# Parameters
Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [switch]
    $DNS
    )


# Hosts
$Computers = @{'host1'='10.0.0.1'; 'host2'='10.0.0.3'}
# Test-Connection for each Host
ForEach ($Computer in $Computers.GetEnumerator()){
    # Ping each host
    $Pingtest = Test-Connection -Count 1 -ComputerName $Computer.Value -Quiet
    # Display results
    $Computer = $Computer.Value
    if($Pingtest){ $result = "$Computer is online.."; write $result}
    if(!($Pingtest)){ $result = "$Computer is offline.."; write $result}
}
write ''
$nodns = @()
# Resolve DNS
Write 'DNS Passed:'
if($DNS){
    ForEach ($Computer in $Computers.GetEnumerator()){
        $Computer = $Computer.Name
        try {$DNSLookup = nslookup $Computer}catch{ $nodns += "$Computer unable to resolve DNS" }
        if($DNSLookup -like "*$Computer*"){ $result = "$Computer resolved DNS"; write $result}
        }
}
write ''
# Unable to resolve DNS messages
write 'DNS Failed:'
ForEach ($Computer in $nodns){$nodns}
