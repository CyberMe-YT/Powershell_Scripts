# Get current user logged in
$cuser = $env:USERNAME
$regex = ''
# Read file and compare $cuser to get true/false for each
foreach($line in Get-Content -Path "\\10.0.0.2\testShare\Password Check scripts\UsersExpire.txt"){
    if($line -match $regex){
        if($line -match $cuser){
            # Warning Prompt
powershell -WindowStyle hidden -Command "& {[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); [System.Windows.Forms.MessageBox]::Show('Account Expiration in less then 30 days. Contact office. ','WARNING')}"
        }
    }
        
}