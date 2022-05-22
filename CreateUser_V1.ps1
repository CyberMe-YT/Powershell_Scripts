

# Create timespan for account expiry
$tspan = New-Timespan -Days 365

# Ask user for unit
$Unit = Read-Host "Please enter unit (Org1,Org2)"
# Copy user template based on input
if ( $Unit -eq 'Org1' )
{
    #Org1

    # Get User information
    $fname = Read-Host "Please enter first name"
    $lname = Read-Host "Please enter last name"
    $sname = ($fname + '.' + $lname)
    $dname = ($fname + ' ' + $lname)
    $upn = ($sname + '@cyberme.local')
    $tDate = Get-Date -Format "yyyy/MM/dd"
    $accexpire = (Get-DAte) + $tspan
    $u = Get-ADUser -Identity _Template1 -Properties Description,Office,OfficePhone
    # Get User Groups from Template
    $ugroups = Get-ADPrincipalGroupMembership -Identity _Template1
    # Create user
    New-ADUser -SamAccountName $sname -Instance $u -UserPrincipalName $upn -Surname $lname -GivenName $fname -Name $dname -Description ("Reviewed:"+$tDate) -AccountExpirationDate $accexpire
    # Give user groups
    $ugroups | foreach { Add-ADPrincipalGroupMembership -Identity $sname -MemberOf $_ -ErrorAction SilentlyContinue }
}
elseif ( $Unit -eq 'Org2' )
{
    # Org2

    # Get User information
    $fname = Read-Host "Please enter first name"
    $lname = Read-Host "Please enter last name"
    $sname = ($fname + '.' + $lname)
    $dname = ($fname + ' ' + $lname)
    $upn = ($sname + '@cyberme.local')
    $tDate = Get-Date -Format "yyyy/MM/dd"
    $u = Get-ADUser -Identity _Template2 -Properties Description,Office,OfficePhone
    # Get User Groups from Template
    $ugroups = Get-ADPrincipalGroupMembership -Identity _Template2
    # Create user
    New-ADUser -SamAccountName $sname -Instance $u -UserPrincipalName $upn -Surname $lname -GivenName $fname -Name $dname -Description ("Reviewed:"+$tDate)
    # Give user groups
    $ugroups | foreach { Add-ADPrincipalGroupMembership -Identity $sname -MemberOf $_ -ErrorAction SilentlyContinue }
}
Else
{
    #Bad input
}
