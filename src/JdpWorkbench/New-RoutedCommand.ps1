function New-RoutedCommand {

    [OutputType('System.Windows.Input.RoutedUICommand')]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Description,

        [Parameter(Mandatory=$true)]
        [string] $Name,

        [Parameter(Mandatory=$false)]
        [Array] $Gesture
    )

    if ($Gesture) {
        [System.Windows.Input.InputGestureCollection] $GestureCollection = New-Object System.Windows.Input.InputGestureCollection
        foreach ($item in $Gesture) {
            $GestureCollection.Add($item) | Out-Null
        }
        $Command = New-Object System.Windows.Input.RoutedUICommand -ArgumentList $Description, $Name, ([Type]"System.Object"), $GestureCollection
    } else {
        $Command = New-Object System.Windows.Input.RoutedUICommand -ArgumentList $Description, $Name, ([Type]"System.Object")
    }

    return $Command
}