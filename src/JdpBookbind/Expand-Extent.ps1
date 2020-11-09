Function Expand-Extent {
    [CmdletBinding()]
    Param(
		[string] $Extent
	)

	$Items = @()
	$SubExtents = $null

	if ($Extent.Contains(',')) {
		$SubExtents = $Extent.Split(',')
	} else {
		$SubExtents = @( $Extent )
	}

	foreach ($SubExtent in $SubExtents) {
		if ($SubExtent.Contains('-')) {
			[int] $start, [int] $end = $SubExtent.Split('-', 2)
			$Items += $start .. $end
		} else {
			if ($SubExtent -eq '_') {
				$Items += ,$null
			} else {
				$Items += ,[int] $SubExtent
			}
		}
	}

	return $Items
}