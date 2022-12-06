# Script can be used to parse CSV file from vulnerator to get IP and file path
# Which can then be exported to a CSV to be imported in another script to rename files or whatever

Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]
    $csvpath,
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]
    $pluginid)

$csvfile = import-csv $csvpath
$csvfile = $csvfile | where "Plugin ID" -eq $pluginid

$myObject = @()

foreach($object in $csvfile){
$ip = $object.'IP Address'
$output = $object.'Scan Output'

$output = $output.Remove(0,20)
$output = $output.Substring(0, $output.IndexOf('Installed'))
$output = $output.trim()

$myobject += New-Object -TypeName psobject -Property @{IP = "$ip"; Path = "$output"}

}
$myobject
$myobject | export-csv 'filepath'
