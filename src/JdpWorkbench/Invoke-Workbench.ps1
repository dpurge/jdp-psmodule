function Invoke-Workbench {
    [OutputType('JDP.Workbench')]
    param()
    
    $Workbench = Get-Workbench
    $Workbench.WriteHello()
}