####################################
# Install multiple drivers from zip#
# Date: October 25 2022            #
####################################


# Parameters
Param(
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True)]
    [string[]]
    $Path
)

# Create Drivers directory if not created to place temp files inside
if (!(Test-Path -Path $Path\Temp_Drivers)){
    New-Item -Name 'Temp_Drivers' -ItemType 'directory' -Path $Path
}
# Unzip files
Get-ChildItem -Filter '*.zip' | foreach { Expand-Archive -Path $_.Name -DestinationPath $Path/Temp_Drivers }
# Install Drivers
Get-ChildItem -Path $Path\Temp_Drivers -Recurse -Filter '*.inf' | foreach { pnputil.exe /add-driver $_.FullName /install }
# cleanup Drivers folder
if (Test-Path -Path $Path\Temp_Drivers){
    Remove-Item -Recurse -Path $Path\Temp_Drivers
}
