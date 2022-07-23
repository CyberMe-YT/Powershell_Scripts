
# Test path to UsersExpire.txt, delete if exists
$file = 'C:\Users\admin\Documents\UsersExpire.txt'
            # Test if path exists, delete if so
            if (Test-Path -Path  $file){
                Remove-Item $file
                # Create blank file
                $null = New-Item $file 
            }

# Get users
$users = Get-ADUser -filter * | select -ExpandProperty SamAccountName
# Boolean, get todays date + 30 if gt then edate prompt user
$tdate = (get-date)
$accexpire = [DateTime]$edate -gt $tdate
# Loop through each object, append any true responses
ForEach ($user in $users){
    # Get account expiration date
    $edate = Get-ADUser -identity $user -Properties * | select -ExpandProperty AccountExpirationDate
    # Filter null expiration dates
    if (!($edate -eq $null)){
        # Is acc expire less then 30 days from current date
        $accexpire = ($edate - $tdate | select days)

        if ($accexpire.Days -lt 30){
            # Write hostname to textfile
            Add-Content $file $user
        }
    }    
    }