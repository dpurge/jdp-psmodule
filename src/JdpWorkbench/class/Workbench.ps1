class Workbench : WpfApplication {

    [string] $Message
    [System.Windows.RoutedEventHandler] $MenuItemExit_Click

    #[System.Windows.Input.CommandBinding] $NewCmdBinding = 

    Workbench( [int] $processId, [string] $xamlFile): base($processId, $xamlFile)
	{
        $this.Message = "This is an example message!"
        $this.MenuItemExit_Click = {
            param (
                [Object] $Sender,
                [System.Windows.RoutedEventArgs] $EventArg
            )
    
            [System.Windows.MessageBox]::Show($Sender.Name + $Sender.parent.Message)
            $EventArg.Handled = $true
        }

        $this.widget.MenuItemExit.Add_Click($this.MenuItemExit_Click)
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
}