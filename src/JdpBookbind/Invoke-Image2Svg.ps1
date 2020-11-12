Function Invoke-Image2Pdf {
    [CmdletBinding()]
    Param(
	    [string] $InputDirectory,
		[string] $OutputDirectory,
		[string[]] $Format = @('.png', '.jpg', '.jpeg', '.tif', '.tiff', '.bmp')
	)

	$config = Import-PowerShellDataFile $PSScriptRoot\Configuration.psd1
}
