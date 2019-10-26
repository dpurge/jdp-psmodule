Function Invoke-Book2Image {
    [CmdletBinding()]
    Param(
	    [string] $Book,
        [string] $Name,
        [string] $Image = 'page',
        [string] $PdfImages = "D:\pgm\poppler\bin\pdfimages.exe",
        [string] $DDjVu = "D:\pgm\DjVuLibre\ddjvu.exe"
	)
    
    [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
    [IO.FileInfo] $BookFile = [IO.Path]::GetFullPath($Book)
    if ( -not $BookFile.Exists) { throw "File does not exist: $($BookFile.FullName)"}
    if ( -not $Name) { $Name = $BookFile.Basename }
    [IO.DirectoryInfo] $OutputDirectory = Join-Path $BookFile.Directory.FullName $Name

    switch ($BookFile.Extension) {
        '.pdf' {
            if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
            & $PdfImages -png "$($BookFile.FullName)" "$(Join-Path $OutputDirectory.FullName $Image)"
        }
        '.djvu' {
            if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }
            & $DDjVu -format=tiff -eachpage "$($BookFile.FullName)" "$(Join-Path $OutputDirectory.FullName $Image)-%04d.tiff"
        }
        default {
            throw "Unsupported file format: $($BookFile.Extension)"
        }
    }
}
