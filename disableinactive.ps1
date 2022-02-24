$inactivity = New-TimeSpan -Days 90
Search-ADAccount -UsersOnly -AccountInactive -TimeSpan $inactivity | Disable-ADAccount
