function Get-AssemblyCustomAttribute {

	PARAM(
        [Parameter(Position=0,ValueFromPipeline=$true)]
        [IO.DirectoryInfo]$Directory
    )
	
	if (-not $Directory.Exists) {throw "Directory does not exist: {0}" -F $Directory.FullName}
	
	$AssemblyFiles = Get-ChildItem $Directory -Include *.exe,*.dll -Recurse
	[System.Collections.ArrayList] $AssemblyCustomAttributes = @()
	
	foreach($AssemblyFile in $AssemblyFiles) {
		$CustomAttribute = New-Object PSObject -Prop @{}
        $CustomAttribute.PSTypeNames.Insert(0, 'DotNetTools.AssemblyCustomAttribute')
	    $Assembly  = [Reflection.Assembly]::LoadFile($AssemblyFile.FullName)
		$CustomAttribute | Add-Member -NotePropertyName 'AssemblyName' -NotePropertyValue $Assembly.GetName().Name
        $CustomAttribute | Add-Member -NotePropertyName 'AssemblyVersion' -NotePropertyValue $Assembly.GetName().Version
        foreach ($Attribute in ($Assembly.GetCustomAttributes($True) | Where-Object {$_.TypeId.Name -eq 'AssemblyMetadataAttribute'} | Select-Object Key,Value)) {
            $CustomAttribute | Add-Member -NotePropertyName $Attribute.Key -NotePropertyValue $Attribute.Value
        }
        $AssemblyCustomAttributes.Add($CustomAttribute) | Out-Null
	}
	
	$AssemblyCustomAttributes
}
