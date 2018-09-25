class Workbench : WpfApplication {

    [string] $Message
    [System.Windows.RoutedEventHandler] $MenuItemExit_Click

    [System.Windows.Input.CommandBinding] $NewCommand

    Workbench( [int] $processId, [string] $xamlFile): base($processId, $xamlFile)
	{
        $this.Message = "This is an example message!"
        
        $this.MenuItemExit_Click = {
            param (
                [Object] $Sender,
                [System.Windows.RoutedEventArgs] $EventArg
            )
    
            [System.Windows.MessageBox]::Show($Sender.Name + " " + $EventArg)
            $EventArg.Handled = $true
        }
        

        #$this.NewCommand = New-Object -TypeName System.Windows.Input.CommandBinding -ArgumentList $this.NewCommand_CanExecute, $this.NewCommand_Executed

        $this.widget.MenuItemExit.Add_Click($this.MenuItemExit_Click)
        $this.setupCommands()
    }

    [void] MenuItemExit_Click2 (
        [Object] $Sender,
        [System.Windows.RoutedEventArgs] $EventArg
    ) {
        [System.Windows.MessageBox]::Show($Sender.Name)
        $EventArg.Handled = $true
    }

    [void] NewCommand_CanExecute ([Object] $Sender, [System.Windows.Input.CanExecuteRoutedEventArgs] $EventArg)
    {
        $EventArg.CanExecute = $true
    }

    [void] NewCommand_Executed ([Object] $Sender, [System.Windows.Input.ExecutedRoutedEventArgs] $EventArg)
    {
        [System.Windows.MessageBox]::Show("Hello there!")
    }

    [void] setupCommands() {

        #[ScriptBlock] $CanExecute = { $_.CanExecute = $true }
        [ScriptBlock] $Exec = {
            param (
                [Object] $Sender,
                [System.Windows.RoutedEventArgs] $EventArg
            )
            [System.Windows.MessageBox]::Show("New command executed by ${sender}")
        }

        $KeyGesture = New-KeyGesture -Key "F5" -ModifierKeys @("Alt") -DisplayText "Alt+F5"
        $Command = New-RoutedCommand -Description "New command" -Name "NewX" -Gesture $KeyGesture
        New-CommandBinding -BindTarget $this.window -Command $Command -Exec $Exec

        #$CommandBind = New-Object System.Windows.Input.CommandBinding -ArgumentList $Command, $Executed, $CanExecute
        #[System.Windows.UIElement] $BindingTarget = $this.window
        #$BindingTarget.CommandBindings.Add($CommandBind) | Out-Null 
    }
    
}