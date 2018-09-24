function Get-Workbench {
    [OutputType('JDP.Workbench')]
    param()
    
    $Workbench = New-Module -ScriptBlock (
        & $PsScriptRoot\Workbench\Workbench.ps1) -AsCustomObject
    $Workbench.PSTypeNames.Insert(0, 'JDP.Workbench')
    
    return $Workbench
}