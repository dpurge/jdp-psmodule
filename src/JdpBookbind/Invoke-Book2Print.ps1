Function Invoke-Book2Print {
    [CmdletBinding()]
    Param(
	    [string] $Book,
		[string] $Extent,
		[string] $Name,
		[int]    $Sheets = 8
	)

	$config = JdpBookbind\Import-Configuration
	[System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
    
	$PagesPerGathering = 4 * $Sheets
    
    [IO.FileInfo] $BookFile = [IO.Path]::GetFullPath($Book)
    if ( -not $BookFile.Exists) { throw "File does not exist: $($BookFile.FullName)"}
    if ( -not $Name) { $Name = $BookFile.Basename }
	[IO.DirectoryInfo] $OutputDirectory = Join-Path $BookFile.Directory.FullName $Name

	$Pages = Expand-Extent -Extent $Extent
	while ($Pages.Length % $PagesPerGathering -ne 0) {
		$Pages += ,$null
	}

	$Index = 0
	$Counter = 0
	while ($Index -lt $Pages.Length - 1) {
		$Counter++
		$Gathering = $Pages[$Index .. ($Index + $PagesPerGathering - 1)]

		$PrintSequence = @()
		$start = 0
		$end = $Gathering.Length - 1
		while ($start -lt $end) {
			$PrintSequence += $Gathering[$end], $Gathering[$start], $Gathering[$start+1], $Gathering[$end-1] 
			$start += 2
			$end -= 2
		}

		$infile = $BookFile.FullName
		$outfile = Join-Path `
			-Path $OutputDirectory `
			-ChildPath ("{0}-{1:D3}.pdf" -f $BookFile.BaseName, $Counter)

		switch ($BookFile.Extension) {
			'.pdf' {
				$BlankPage = Join-Path -Path $PsScriptRoot -ChildPath $config.Blank.Pdf.a5
				if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
				$pgm = $config.Tools.PDFtk
				$pgmParam =  ,"A=`"${infile}`""
				$pgmParam +=  ,"B=`"${BlankPage}`""
				$pgmParam +=  ,"cat"
				$pgmParam +=  ($PrintSequence | ForEach-Object { if($_) {"A${_}"} else {"B1"} })
				$pgmParam +=  ,"output"
				$pgmParam +=  ,"`"${outfile}`""
				& $pgm @pgmParam
				if ($?) {
					Write-Output $outfile
				} else {
					$msg = $Error[0].Exception.Message
					Write-Error "Error in chunk ${Counter}: ${msg}"
					#exit
				}
				
			}
			default {
				throw "Unsupported file format: $($BookFile.Extension)"
			}
		}

		$Index += $PagesPerGathering
	}
	
}