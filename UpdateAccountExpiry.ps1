# User completed annual training and account expiry needs to be updated

# Ask for user
$user = Read-Host "Search by username: "
# Search AD and assign all users to list
$userlist = Get-AdUser -Filter *| ForEach-Object -MemberName SamAccountName
Write-Host "Searching AD for user........"
Start-Sleep -Seconds 0
# User Exists in AD
if ($userlist -contains $user){
    Write-Host "User found!"
    Get-ADUser $user
    $userv = Read-Host "Is this the user you are looking to update? (y/n)"
    # Verified correct user
    if ($userv.ToLower() -eq 'y'){
        $todaydate = Get-Date -Format yyyy/MM/dd
        $traindate = Read-host "Was training performed today,", $todaydate, " (y/n)"
        # Training was performed today, Today + 365
        if ($traindate.ToLower() -eq 'y'){
            $tspan = New-Timespan -Days 365
            $accexpire = (Get-Date) + $tspan
            Set-ADAccountExpiration -Identity $user -DateTime $accexpire
            Set-AdUser -Identity $user -Description ("Reviewed:"+$todaydate)
            #Update Complete prompts
            Write-Host "Updating User......"
            Start-Sleep -Seconds 2
            Write-Host "Update Complete...."
            Start-Sleep -Seconds 5
        # Training was performed prior to today, Date + 365
        }elseif ($traindate.ToLower() -eq 'n'){
            $tdate = Read-Host "Training date (mm/dd/yyyy)"
            $accexpire = [datetime]$tdate
            $accexpire = $accexpire.AddDays(365)
            Set-ADAccountExpiration -Identity $user -DateTime $accexpire
            Set-AdUser -Identity $user -Description ("Reviewed:"+$todaydate)
            #Update Complete prompts
            Write-Host "Updating User......"
            Start-Sleep -Seconds 2
            Write-Host "Update Complete...."
            Start-Sleep -Seconds 5
        }else{ # Invalid input for training date
            Write-Host "You stupid. Quit"
            Start-Sleep -Seconds 3
            Exit
        }
    # Invalid input for correct user
    }else{ 
        write-host "Try again. Will exit in 5 seconds"
        Start-Sleep -Seconds 5
        Exit
    }

 # User Does not exist
}Else{
    Write-Host "User does not exist. Exiting program....."
    Start-Sleep -Seconds 5
    Exit
}