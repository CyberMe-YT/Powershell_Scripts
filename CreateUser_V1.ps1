

# Create timespan for account expiry
$tspan = New-Timespan -Days 365

# Ask user for unit
$unitlist = @('Org1','Org2')
$Unit = Read-Host "Please enter unit (Org1,Org2)"

# Input validation
if ($Unit -in $unitlist){
    Clear-Host
}
# Unit Does not exist, exit program
Else{
    Write-Host "Unit does not exist."
    Start-Sleep -Seconds 10
    Exit
}

# Get user information
$fname = Read-Host "Please enter first name"
$lname = Read-Host "Please enter last name"
$sname = ($fname + '.' + $lname)
$dname = ($fname + ' ' + $lname)
$upn = ($sname + '@cyberme.local')
$tDate = Get-Date -Format "yyyy/MM/dd"
$accexpire = (Get-DAte) + $tspan

# Copy user template based on input
if ( $Unit.ToLower() -eq 'org1' ){
    #Org1
    $u = Get-ADUser -Identity _Template1 -Properties Description,Office,OfficePhone
    # Get User Groups from Template
    $ugroups = Get-ADPrincipalGroupMembership -Identity _Template1
    # Create user
    New-ADUser -SamAccountName $sname -Instance $u -UserPrincipalName $upn -Surname $lname -GivenName $fname -Name $dname -Description ("Reviewed:"+$tDate) -AccountExpirationDate $accexpire
    # Give user groups
    $ugroups | foreach { Add-ADPrincipalGroupMembership -Identity $sname -MemberOf $_ -ErrorAction SilentlyContinue }
}
elseif ( $Unit.ToLower() -eq 'org2' ){
    # Org2
    $u = Get-ADUser -Identity _Template2 -Properties Description,Office,OfficePhone
    # Get User Groups from Template
    $ugroups = Get-ADPrincipalGroupMembership -Identity _Template2
    # Create user
    New-ADUser -SamAccountName $sname -Instance $u -UserPrincipalName $upn -Surname $lname -GivenName $fname -Name $dname -Description ("Reviewed:"+$tDate)
    # Give user groups
    $ugroups | foreach { Add-ADPrincipalGroupMembership -Identity $sname -MemberOf $_ -ErrorAction SilentlyContinue }
}

# Verify results
Clear-Host
Write-Host "Account created for: $sname"
Write-Host "Properties of user:"
Start-Sleep -Seconds 0
Get-ADUser -Identity $sname -Properties *
# Enable Account
$userenable = Read-Host "Would you like to enable account for $sname? (y/n): "
if ($userenable.ToLower() -eq 'y'){
    Set-ADAccountPassword -Identity $sname -Reset 
    write-host "Enabled"
    Enable-ADAccount -Identity $sname
}
# Keep Account disabled
elseif ($userenable.ToLower() -eq 'n') {
    write-host "Disabled"
}
# Input validation
else{
    write-host "Error: unable to compute human idiocracy"
    Start-Sleep -Seconds 5
    Exit
}