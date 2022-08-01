# Script to change subnet to connect to VMNet #
###############################################

# Parameters
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [ValidateSet('vmnet','prodnet')]
    [string]$net
    )
# Get adapter information
$adapter = Get-NetAdapter | ? {$_.Name -eq "Ethernet" }
 
# VM Network
if ( $net -eq 'vmnet'){
   $ip = "10.0.0.9"
   $mask = 24 # subnet 255.255.255.0
   $gate = "10.0.0.1"
   $DNS = "10.0.0.2"
   # Remove existing gateway
   if(($adapter | Get-NetIPConfiguration).ipv4defaultgateway){
        $adapter | Remove-NetRoute -Confirm:$false
   }
   # Enable DHCP to remove original settings
   $adapter | Set-NetIPInterface -DHCP Enabled
   # Set Static IP address for VM Net
   $adapter | New-NetIPAddress `
   -AddressFamily IPv4 `
   -IPAddress $ip `
   -PrefixLength $mask `
   -DefaultGateway $gate
   # DNS
   $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
   ipconfig /flushdns


}

# Prod Network
if ( $net -eq 'prodnet'){
   $ip = "192.168.1.99"
   $mask = 24 # subnet 255.255.255.0
   $gate = "192.168.1.1"
   $DNS = "192.168.1.1"
   # Remove existing gateway
   if(($adapter | Get-NetIPConfiguration).ipv4defaultgateway){
        $adapter | Remove-NetRoute -Confirm:$false
   }
   # Enable DHCP to remove original settings
   $adapter | Set-NetIPInterface -DHCP Enabled
   # Set Static IP address for VM Net
   $adapter | New-NetIPAddress `
   -AddressFamily IPv4 `
   -IPAddress $ip `
   -PrefixLength $mask `
   -DefaultGateway $gate
   # DNS
   $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
   ipconfig /flushdns

}