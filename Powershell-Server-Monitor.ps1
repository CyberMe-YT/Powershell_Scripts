add-type -AssemblyName PresentationFramework

# WPF Window
$window = New-Object System.Windows.Window
$window.title = "Server Monitor"
$window.Width = 400
$window.Height = 300

$grid = New-Object System.Windows.Controls.Grid

function CreateHostUI {
    param (
        [string]$hostname,
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
    $label.Content = $hostname
    $label.HorizontalAlignment = "Left"
    $label.VerticalAlignment = "Top"
    $label.Margin = $labelMargin

    return $circle, $label

}

$hostsToMonitor = @("192.168.1.2", "bing.com", "192.168.1.33")
$hosts = @{}
$topMargin = 25


foreach ($h in $hostsToMonitor) {
    $newTopMargin = $topMargin - 10
    $circleMargin = New-Object System.Windows.Thickness(15,$topMargin, 0, 0)
    $labelMargin = New-Object System.Windows.Thickness(30, $newTopMargin, 0, 0)
    $circle, $label = CreateHostUI -hostname $h -color "Red" -circleMargin $circleMargin -labelMargin $labelMargin

    $grid.Children.Add($circle)
    $grid.Children.Add($label)

    $hosts[$h] = $circle

    $topMargin += 25


}

function CheckConnection {
    param (
        [hashtable]$hosts
    )

    foreach ($h in $hosts.keys) {
        if (test-connection -computername $h -count 1 -Quiet) {
            $hosts[$h].Fill = "Green"
        } else {
            $hosts[$h].Fill = "Red"
        }

    }
}

$window.Content = $grid

$timer = New-object System.Windows.Threading.DispatcherTimer
$timer.interval = [TimeSpan]::FromSeconds(5)
$timer.Add_tick({CheckConnection -hosts $hosts})
$timer.Start()



# Display window
$window.ShowDialog() | out-null