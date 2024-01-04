Add-Type -AssemblyName PresentationFramework

# WPF window
$window = New-Object System.Windows.Window
$window.Title = "Server Status"
$window.Width = 400
$window.Height = 300

# Gird to hold UI elements
$grid = New-Object System.Windows.Controls.Grid

# GOOGLE
$circle_google = New-Object System.Windows.Shapes.Ellipse
$circle_google.Width = 10
$circle_google.Height = 10
$circle_google.HorizontalAlignment = "Left"
$circle_google.VerticalAlignment = "Top"
$circle_google.Fill = "Red" # Set initial color to green
$circle_google.Margin = New-Object System.Windows.Thickness(0, 25, 0, 0) # Set margin to 0

$label_google = New-Object System.Windows.Controls.Label
$label_google.Content = "Google"
$label_google.HorizontalAlignment = "Left"
$label_google.VerticalAlignment = "Top"
$label_google.Margin = New-Object System.Windows.Thickness(15, 15, 0, 0) # Set margin to 0


# BING
$circle_bing = New-Object System.Windows.Shapes.Ellipse
$circle_bing.Width = 10
$circle_bing.Height = 10
$circle_bing.HorizontalAlignment = "left"
$circle_bing.VerticalAlignment = "Top"
$circle_bing.Fill = "Red" # Set initial color to green
$circle_bing.Margin = New-Object System.Windows.Thickness(0, 50, 0, 0) # Set margin to 0

$label_bing = New-Object System.Windows.Controls.Label
$label_bing.Content = "Bing"
$label_bing.HorizontalAlignment = "Left"
$label_bing.VerticalAlignment = "Top"
$label_bing.Margin = New-Object System.Windows.Thickness(15, 40, 0, 0) # Set margin to 0



# Add the circle and label to the grid
$grid.Children.Add($circle_google)
$grid.Children.Add($circle_bing)
$grid.Children.Add($label_google)
$grid.Children.Add($label_bing)

# Add the grid to the window
$window.Content = $grid

function CheckConnectivity {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$hosts
    )


    foreach ($entry in $hosts.GetEnumerator()) {
        $ComputerName = $entry.Name
        $circle = $entry.Value
        Write-Output $ComputerName
        $connected = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet

        if ($connected) {
            $circle.Fill = "Green"
        } else {
            $circle.Fill = "Red"
        }
    }
}

# Create a hashtable of hosts and their corresponding circle objects
$hosts = @{
    "google.com" = $circle_google
    "bing.com" = $circle_bing
}


# Call the CheckConnectivity function every 5 seconds
$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(5)
$timer.Add_Tick({ CheckConnectivity -hosts $hosts })
$timer.Start()

# Show the window
$window.ShowDialog() | Out-Null
