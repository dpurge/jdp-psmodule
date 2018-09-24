{
    # P R O P E R T I E S
    [string] $Name = "JDP Workbench"
    
    # M E T H O D S
    function WriteHello { Write-Host "Hello from $( $this.Name )!" }
    
    # E X P O R T S
    Export-ModuleMember -Function * -Variable *
}