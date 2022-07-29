# Ask for user to disable
$udisable = Read-Host "Enter username:"
# Verify user exists, error handle
$User = $(try{get-aduser $udisable} catch {$null})

if ($User -ne $Null) {
    Disable-ADAccount -Identity $udisable
    Get-Aduser -Identity $udisable | Select-Object SamAccountName, Enabled

} Else {
    Write-Host "User does not exist"
    exit
}