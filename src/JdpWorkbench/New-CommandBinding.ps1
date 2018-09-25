function New-CommandBinding {

    param (
        $BindTarget,
        $Command,
        $Exec,
        $CanExec = { $_.CanExecute = $true },
        $KeyBindTarget
    )

    $CommandBind = New-Object System.Windows.Input.CommandBinding -ArgumentList $Command, $Exec, $CanExec
    $BindTarget.CommandBindings.Add($CommandBind) | Out-Null
    if ($KeyBindTarget) {
        $KeyBindTarget.Command = $Command
    }
}