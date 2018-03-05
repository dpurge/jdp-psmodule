function Get-Example {

	[OutputType('JdpBookbind.Example')]
    param (
	    [Parameter(Mandatory = $true, Position=0, ValueFromPipeline=$true, ParameterSetName='Message')]
	    [String] $Message
	)
	
	$example = New-Object PSObject -Prop @{
	    GUID = [guid]::NewGuid()
	    Message = $Message
	}
	
	$example.PSTypeNames.Insert(0, 'JdpBookbind.Example')
	
	return $example
}