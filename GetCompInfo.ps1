#################################################################
# Purpose: Get various computer info from domain                #
#                                                               #
#################################################################
# Parameters
param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)] [ValidateSet('osbuildnumber','OSType','OsVersion')]
    [string]$selectob
    )
# Get Computer Info for all computers
$ErrorActionPreference = 'silentlycontinue'
$computers = Get-ADComputer -filter * | Select -ExpandProperty name
$cinfo = Invoke-Command -ComputerName $computers -ScriptBlock { get-computerinfo } | Select PSComputerName,$selectob
$cinfo