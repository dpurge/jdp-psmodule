Function Invoke-Pdf2Image {
    [CmdletBinding()]
    Param(
	    [IO.FileInfo] $PdfFile,
		[string] $Name
	)
	
	$PDFIMAGES="D:\pgm\poppler\bin\pdfimages.exe"
	
	[IO.DirectoryInfo] $OutputDirectory = Join-Path $PdfFile.Directory.FullName $Name
	if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
	
	& $PDFIMAGES -png $PdfFile.FullName (Join-Path $OutputDirectory.FullName $Name)
}
