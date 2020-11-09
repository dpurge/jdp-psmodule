Function Invoke-Book2Print {
    [CmdletBinding()]
    Param(
	    [string] $Book,
		[string] $Extent,
		[string] $Name,
		[int]    $Sheets = 8
	)

	$PagesPerGathering = 4 * $Sheets
    
    [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
    [IO.FileInfo] $BookFile = [IO.Path]::GetFullPath($Book)
    if ( -not $BookFile.Exists) { throw "File does not exist: $($BookFile.FullName)"}
    if ( -not $Name) { $Name = $BookFile.Basename }
	[IO.DirectoryInfo] $OutputDirectory = Join-Path $BookFile.Directory.FullName $Name

	$Pages = Expand-Extent -Extent $Extent
	while ($Pages.Length % $PagesPerGathering -ne 0) {
		$Pages += ,$null
	}

	$Index = 0
	while ($Index -lt $Pages.Length - 1) {
		$Gathering = $Pages[$Index .. ($Index + $PagesPerGathering - 1)]

		$PrintSequence = @()
		$start = 0
		$end = $Gathering.Length - 1
		while ($start -lt $end) {
			$PrintSequence += $Gathering[$start], $Gathering[$start+1], $Gathering[$end-1], $Gathering[$end]
			$start += 2
			$end -= 2
		}

		switch ($BookFile.Extension) {
			'.pdf' {
				if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
				Write-Host ($PrintSequence -join '-')
			}
			default {
				throw "Unsupported file format: $($BookFile.Extension)"
			}
		}

		$Index += $PagesPerGathering
	}
	
}