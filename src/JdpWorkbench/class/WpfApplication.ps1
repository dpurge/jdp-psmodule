class WpfApplication
{
	$process
    [xml] $xaml
	$window
	$widget
	$context
	
	WpfApplication( [int] $processId, [string] $xamlFile )
	{
	    $this.process = Get-Process -PID $processId
	    $this.xaml = [xml](Get-Content $xamlFile)
		$this.window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $this.xaml))
		$this.widget = @{}
		foreach ($i in $this.xaml.SelectNodes("//*[@Name]")) {
		    $this.widget.add(($i.Name), $this.window.FindName($i.Name))
		}
		$this.window.Add_Closed({
			[System.Windows.Forms.Application]::Exit()
		})
		
		$this.context = New-Object System.Windows.Forms.ApplicationContext 
	}
	
	[Void] setIcon($bitmap) {
	    $this.window.Icon = $bitmap
		$this.window.TaskbarItemInfo.Overlay = $bitmap
        $this.window.TaskbarItemInfo.Description = $this.window.Title
	}
	
	Run()
	{
	    $asyncwindow = Add-Type -name Win32ShowWindowAsync -namespace Win32Functions -PassThru -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
		try {
		    $asyncwindow::ShowWindowAsync($this.process.MainWindowHandle, 0) | Out-Null
			[System.Windows.Forms.Integration.ElementHost]::EnableModelessKeyboardInterop($this.window)
			$this.window.Show()
			$this.window.Activate()
			[void][System.Windows.Forms.Application]::Run($this.context)
		} finally {
		    $asyncwindow::ShowWindowAsync($this.process.MainWindowHandle, 3) | Out-Null
		}
	}
}