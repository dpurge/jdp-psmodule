function Get-XmlElementDescription {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
	    Get-XmlElementDescription -Document $xml1, $xml2 -ElementPath "/root/configuration"
    .OUTPUTS
    .NOTES
        Author: JDP
    .LINK
    #>
	
	PARAM(
	    [xml[]] $Document,
		[string] $ElementPath
    )
	
	
    $elements = @{
	    attributes = @{};
		children = @();
	}
	
	foreach ($doc in $Document) {
		foreach ($i in ($doc.SelectNodes("$ElementPath/@*"))) {
		    $Name = $i.get_Name()
		    $Value = $i.get_Value()
			if ($elements.attributes.keys -notcontains $Name) {
				$elements.attributes[$i.Name] = @()
			}
			if ($elements.attributes[$Name] -notcontains $Value) {
				$elements.attributes[$Name] += $Value
			}
		}
		foreach ($i in ($doc.SelectNodes("$ElementPath/*"))) {
		    $Name = $i.get_Name()
			if ($elements.children -notcontains $Name) {
				$elements.children += $Name
			}
		}
	}
	
	Write-Host $ElementPath
	Write-Host "`tAttributes:"
	foreach ($i in $elements.attributes.keys) {
	    Write-host ("`t`t{0}: {1}" -F $i, ($elements.attributes[$i] -join ', '))
	}
	Write-Host "`tChild nodes:"
	foreach ($i in $elements.children) {
	    Write-host "`t`t$i"
	}
	
}