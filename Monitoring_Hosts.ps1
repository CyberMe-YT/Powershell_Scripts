Add-Type -AssemblyName PresentationFramework

# WPF window
$window = New-Object System.Windows.Window
$window.Title = "Server Status"
$window.Width = 400
$window.Height = 300

# Grid to hold UI elements
$grid = New-Object System.Windows.Controls.Grid

function CreateHostUIElement {
    param (
        [string]$hostName,
        [string]$color,
        [System.Windows.Thickness]$circleMargin,
        [System.Windows.Thickness]$labelMargin
    )

    $circle = New-Object System.Windows.Shapes.Ellipse
    $circle.Width = 10
    $circle.Height = 10
    $circle.HorizontalAlignment = "Left"
    $circle.VerticalAlignment = "Top"
    $circle.Fill = $color
    $circle.Margin = $circleMargin

    $label = New-Object System.Windows.Controls.Label
    $label.Content = $hostName
    $label.HorizontalAlignment = "Left"
    $label.VerticalAlignment = "Top"
    $label.Margin = $labelMargin

    return $circle, $label
}

$hostsToMonitor = @("192.168.1.253", "bing.com", "192.168.1.2") # Add more hosts here
$hosts = @{}
$topMargin = 25

foreach ($h in $hostsToMonitor) {
    $newTopMargin = $topMargin - 10
    $circleMargin = New-Object System.Windows.Thickness(0, $topMargin, 0, 0)
    $labelMargin = New-Object System.Windows.Thickness(15, $newTopMargin, 0, 0)
    $circle, $label = CreateHostUIElement -hostName $h -color "Red" -circleMargin $circleMargin -labelMargin $labelMargin

    $grid.Children.Add($circle)
    $grid.Children.Add($label)

    $hosts[$h] = $circle

    $topMargin += 25 # Increase the top margin for the next host
}

function CheckConnectivity {
    param (
        [hashtable]$hosts
    )

    foreach ($h in $hosts.Keys) {
        if (Test-Connection -ComputerName $h -Count 1 -Quiet) {
            $hosts[$h].Fill = "Green"
        } else {
            $hosts[$h].Fill = "Red"
        }
    }
}



# Add the grid to the window
$window.Content = $grid


$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromSeconds(5) # Check connectivity every 5 seconds
$timer.Add_Tick({ CheckConnectivity -hosts $hosts })
$timer.Start()

# Show the window
$window.ShowDialog() | Out-Null