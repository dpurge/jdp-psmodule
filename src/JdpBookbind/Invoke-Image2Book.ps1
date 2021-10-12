Function Invoke-Image2Book {
    [CmdletBinding()]
    Param(
        [string] $Book,
        [string] $Name,
        [string] $Image = 'page',
        [string] $Format = 'tif',
        [switch] $Color,
        [switch] $Convert,
        [switch] $NumberSuffix
    )

	$config = JdpBookbind\Import-Configuration
	$ImageMagick = $config.Tools.ImageMagick
	$CJB2 = $config.Tools.CJB2
	$CpalDjvu = $config.Tools.CpalDjvu
	$Djvm = $config.Tools.Djvm
	$Ddjvu = $config.Tools.DDjVu
    
    [System.IO.Directory]::SetCurrentDirectory(((Get-Location -PSProvider FileSystem).ProviderPath))
    [IO.DirectoryInfo] $BookDirectory = [IO.Path]::GetFullPath($Book)
    if ( -not $BookDirectory.Exists) { throw "Directory does not exist: $($BookDirectory.FullName)"}

    [IO.FileInfo[]] $Pages = Get-Item (Join-Path $BookDirectory.FullName "*.${Format}")
    if ($NumberSuffix) {
        $Pages = $Pages | Sort-Object -Property {@([int]($_.BaseName -split '(\d+)$')[1])}
    } else {
        $Pages = Sort-Object -InputObject $Pages -Property Name
    }

    if (-not $Name) { $Name = "jdp-$($BookDirectory.Name)"}
    [IO.DirectoryInfo] $OutputDirectory = Join-Path $BookDirectory.Parent.FullName $Name
    if ( -not $OutputDirectory.Exists) { $OutputDirectory.Create() }

    [int] $PageNr = 0
    foreach ($Page in $Pages) {
        $PageNr += 1
        $NewPageName = "${Image}-$($PageNr.ToString('0000')).djvu"

        [IO.FileInfo] $NewPage = Join-Path $OutputDirectory.FullName $NewPageName

        if ($NewPage.Exists) {
		    Write-Warning "File already exists: $($NewPage.FullName)"
		} else {
            if ($Color) {
                if ($Convert -or $Page.Extension -ne '.jpg') {
                    [IO.FileInfo] $TempPage = Join-Path $OutputDirectory.FullName "$($NewPage.BaseName).jpg"
                    & "${ImageMagick}" "$($Page.FullName)" "$($TempPage.FullName)"
                    $Page = $TempPage
                }
                & "${CpalDjvu}" -dpi 600 -colors 8 $Page.FullName $NewPage.FullName
            } else {
                if ($Convert -or $Page.Extension -ne '.tif') {
                    [IO.FileInfo] $TempPage = Join-Path $OutputDirectory.FullName "$($NewPage.BaseName).tif"
                    & "${ImageMagick}" "$($Page.FullName)" +dither -colors 2 -colorspace gray -normalize -compress group4 "$($TempPage.FullName)"
                    $Page = $TempPage
                }
                & "${CJB2}" -dpi 600 "$($Page.FullName)" "$($NewPage.FullName)"
            }
        }
    }

    & "${Djvm}" -c "$($OutputDirectory.FullName).djvu" "$($OutputDirectory.FullName)\*.djvu"
    if ($Color) {
        & "${Ddjvu}" -format=pdf "$($OutputDirectory.FullName).djvu" "$($OutputDirectory.FullName).pdf"
    } else {
        & "${Ddjvu}" -format=pdf -mode=black "$($OutputDirectory.FullName).djvu" "$($OutputDirectory.FullName).pdf"
    }
}