Function Invoke-Image2Pdf {
    [CmdletBinding()]
    Param(
	    [IO.DirectoryInfo] $Directory,
		[string] $Format,
		[string] $Convert,
		[string] $Name
	)
	
	$ImageMagickExe = "D:\pgm\ImageMagick\convert.exe"
	
	[int] $item = 0
	[IO.FileInfo[]] $Images = Get-Item (Join-Path $Directory.FullName "*.${Format}")
	
	[IO.DirectoryInfo] $OutputDirectory = Join-Path $Directory.Parent.FullName $Name
	if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
	
	foreach ($image in $images) {
		$Number = $item.ToString('000')
		$NewFileName = if ( -not $Convert) {"${Name}-${Number}.${Format}"} else {"${Name}-${Number}.${Convert}"}
		
	    [IO.FileInfo] $NewImage = Join-Path $OutputDirectory.FullName $NewFileName
		
		if ($NewImage.Exists) {
		    Write-Warning "Target file already exists: $($NewImage.FullName)"
		}
		
		if ($image.Extension -eq $NewImage.Extension) {
		    Copy-Item $image $NewImage
		} else {
			& $ImageMagickExe $image.FullName $NewImage.FullName
		}
		
	    $item += 1
	}
    
    & $ImageMagickExe "$($OutputDirectory.FullName)\*$($NewImage.Extension)" -density 300 -compress zip "$($OutputDirectory.FullName).pdf"
}
