# Script used to quickly grab Computer info to determine if meets W11 requirements


# Parameters 
Param(
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]
    $ComputerName,
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string[]]
    $ADGroup,
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [switch]
    $export,
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true)]
    [string]
    $path
)

# Verify input, write-errors
if($ADGroup.length -eq 0 -and $ComputerName.Length -eq 0) { Write-Error -Message 'Provide hostname -ComputerName or AD Group membership of computers you would like to search using -ADGroup'; exit }
if($ADGroup.length -eq 1 -and $ComputerName.Length -eq 1) { Write-Error -Message 'Only specify -ComputerName or -ADGroup but not both'; exit }

# Search single host
if(!($ComputerName.Length -eq 0)){ 
    $testobject = @()
    
    # Get Computer info name
    $csname = Invoke-Command { Get-ComputerInfo | Select -ExpandProperty csname}
    # Get CPU
    $cpuname = get-wmiobject win32_processor | select -ExpandProperty Name;
    # Get TPM
    $VersionInfo = "2.0%"
    $NameSpace = "root\CIMV2\Security\MicrosoftTPM"
    try { $TPMVersion = gwmi -Namespace $NameSpace -Class Win32_TPM -ErrorAction SilentlyContinue }catch{$null}
    $TPM = 'Unknown'
    $TPMcheck = if($TPMVersion.SpecVersion -like "*2.0*"){ $TPM = '2.0' }
    # Get Video
    $videocard = Get-WmiObject win32_VideoController | select -ExpandProperty Name;
    # Get UEFI
    $UEFI = invoke-command { Get-ComputerInfo | select -ExpandProperty BiosFirmwareType}

    # Assign properties to object
    $testobject += New-Object -TypeName psobject -Property @{Hostname=[string]$csname; TPM=$TPM; CPU=$cpuname; UEFI=$UEFI; Graphics=[string]$videocard}
    
    if($export){
        # Output to CSV file for record keeping
        $testobject | foreach-object { $_ | Select-Object Hostname, TPM, CPU, UEFI, Graphics | Export-Csv -Append -path $path -NoTypeInformation }
        }
      
     }

# STILL NEEDS TO BE TESTED
# Search AD Group 
if(!($ADGroup.Length -eq 0)) {
    # custom object
    $testobject = @()
    $hostlist = Get-adgroupmember -identity $ADGroup | select name
    ForEach($hostname in $hostlist) { 
        # Get Computer info name
        $csname = Invoke-Command  -ComputerName $hostname -ScriptBlock { Get-ComputerInfo | Select -ExpandProperty csname }
        # Get CPU
        $cpuname = get-wmiobject -Class win32_processor -ComputerName $hostname | select -ExpandProperty Name;
        # Get TPM
        $VersionInfo = "2.0%"
        $NameSpace = "root\CIMV2\Security\MicrosoftTPM"
        try { $TPMVersion = gwmi -Namespace $NameSpace -Class Win32_TPM -ErrorAction SilentlyContinue }catch{$null}
        $TPM = 'Unknown'
        $TPMcheck = if($TPMVersion.SpecVersion -like "*2.0*"){ $TPM = '2.0'}
        # Get Video
        $videocard = Get-WmiObject -Class win32_VideoController -ComputerName $hostname | select -ExpandProperty Name;
        # Get UEFI
        $UEFI = Invoke-Command  -ComputerName $hostname -ScriptBlock { Get-ComputerInfo | select -ExpandProperty BiosFirmwareType }
        
        $testobject += New-Object -TypeName psobject -Property @{Hostname=[string]$csname; CPU=$cpuname; UEFI=$UEFI; Graphics=[string]$videocard}
        # -export switch
        if($export){
            # Output to CSV file for record keeping
            $testobject | foreach-object { $_ | Select-Object Hostname, CPU, UEFI, Graphics | Export-Csv -Append -path [string]$path -NoTypeInformation }
        }

     
    }
    }




# Print table to console
$testobject | ft -Property Hostname, CPU, UEFI, Graphics, TPM
