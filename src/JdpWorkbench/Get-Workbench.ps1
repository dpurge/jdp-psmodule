function Get-Workbench {
    param()
    
    Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration

    . $PSScriptRoot\class\WpfApplication.ps1
    . $PSScriptRoot\class\Workbench.ps1

    $Workbench = New-Object -TypeName Workbench -ArgumentList $pid, "$PSScriptRoot\xaml\Workbench.xaml"

    <#
    $base64 = ""
    $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $bitmap.BeginInit()
    $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($base64)
    $bitmap.EndInit()
    $bitmap.Freeze()
    #>

    #$Workbench.setIcon($bitmap)
    
    return $Workbench
}