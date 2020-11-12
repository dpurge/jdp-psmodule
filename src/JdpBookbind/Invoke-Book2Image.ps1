Function Invoke-Book2Image {
    [CmdletBinding()]
    Param(
	    [string] $InputFile,
        [string] $OutputDirectory,
        [string] $Image = 'page'
	)

	$config = Import-PowerShellDataFile $PSScriptRoot\Configuration.psd1
    $PdfImages = $config.Tools.PdfImages
    $DDjVu = $config.Tools.DDjVu
    
    [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))

    [IO.FileInfo] $BookFile = [IO.Path]::GetFullPath($InputFile)
    if ( -not $BookFile.Exists) { throw "File does not exist: $($BookFile.FullName)"}

    if ( -not $OutputDirectory) { $OutputDirectory = $BookFile.Basename }
    [IO.DirectoryInfo] $OutDir = Join-Path $BookFile.Directory.FullName $OutputDirectory

    switch ($BookFile.Extension) {
        '.pdf' {
            if ( -not $OutDir.Exists) { $OutDir.Create() }
            & $PdfImages -png "$($BookFile.FullName)" "$(Join-Path $OutDir.FullName $Image)"
        }
        '.djvu' {
            if ( -not $OutDir.Exists) { $OutDir.Create() }
            & $DDjVu -format=tiff -eachpage "$($BookFile.FullName)" "$(Join-Path $OutDir.FullName $Image)-%04d.tiff"
        }
        default {
            throw "Unsupported file format: $($BookFile.Extension)"
        }
    }
}
