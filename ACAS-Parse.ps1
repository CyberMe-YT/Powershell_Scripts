# Get Filepath
$fpath = Read-Host 'Enter file path containing Benchmarks'
$tpath = $fpath
# Create temp folder to copy file
if (!(Test-Path -Path $fpath\Temp)){
    $null = New-Item -Path $fpath -Name 'Temp' -ItemType 'directory'
}
# Copy files from specified path and convert to .txt files in Temp
Copy-Item -Path $tpath\*.xml -Destination $tpath\Temp
# For each file in dirfiles rename to .txt
$dirfiles = Get-ChildItem -Path $tpath\Temp
foreach ($file in $dirfiles) {
    $filename = $file | select -ExpandProperty Name
    try { Rename-Item -Path $tpath\Temp\$filename -NewName $tpath\Temp\$filename'.txt' }
    catch { 'Error' }
}
cls
Foreach ($file in $dirfiles){
    $fname = $file | Select -ExpandProperty Name
    Write-Host `n `n `n
    Write-Host 'FILENAME:' $fname 
    # Grab Data Stream ID
    gc -Path $tpath\Temp\$file.txt | Select-String 'Data-Stream id'
    Write-Host `n
    # Grab Benchmark ID
    gc -path $tpath\Temp\$file.txt | Select-String 'xccdf:BenchMark xmlns'
}

# Remove Temp Files
Remove-Item $tpath\Temp\*.txt