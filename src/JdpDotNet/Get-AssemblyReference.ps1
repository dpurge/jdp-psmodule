function Get-AssemblyReference {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
    .OUTPUTS
    .NOTES
        Author: Janusz Prusaczyk
    .LINK
    #>
	
	[OutputType('DotNetTools.AssemblyReference')]
	
	PARAM(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [IO.DirectoryInfo]$Directory
    )
	
	if (-not $Directory.Exists) {throw "Directory does not exist: {0}" -F $Directory.FullName}
	
	$AssemblyFiles = Get-ChildItem $Directory -Include *.exe,*.dll -Recurse
	[System.Collections.ArrayList] $AssemblyReferences = @()
	
	foreach($AssemblyFile in $AssemblyFiles) {
	    $Assembly  = [Reflection.Assembly]::LoadFile($AssemblyFile.FullName)
		$Name = $Assembly.ManifestModule
		$References = $Assembly.GetReferencedAssemblies()
		foreach ($Reference in $References) {    
		    $AssemblyReference = New-Object PSObject -Prop @{
			    Assembly = $Assembly;
				Reference = $Reference;
			}
			$AssemblyReference.PSTypeNames.Insert(0, 'DotNetTools.AssemblyReference')
			$AssemblyReferences.Add($AssemblyReference) | Out-Null
		}
	}
	
	$AssemblyReferences
}
