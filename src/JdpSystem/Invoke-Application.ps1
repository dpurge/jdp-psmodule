function Invoke-Application {

    Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration


    <#
    $base64 = ""



    $bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
    $bitmap.BeginInit()
    $bitmap.StreamSource = [System.IO.MemoryStream][System.Convert]::FromBase64String($base64)
    $bitmap.EndInit()
    $bitmap.Freeze()
    #>


    . $PSScriptRoot\class\WpfApplication.ps1
    $Application = [WpfApplication]::new($pid, "$PSScriptRoot\xaml\MainWindow.xaml")
    #$Application.setIcon($bitmap)
    $Application.Run()
}