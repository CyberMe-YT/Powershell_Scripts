# Get All users from group
$users = Get-AdGroupMember -Identity 'GroupName' | Select Name,ObjectClass
# If user class grab object
foreach($user in $users){
    if(user.ObjectClass -eq 'user'){ $filteredusers += $user.Name }
}
# Update user profile for each user in users
foreach($user in $filteredusers){
    Set-ADUser -Identity $user -ProfilePath '\\network\path\%USERNAME%'
}
