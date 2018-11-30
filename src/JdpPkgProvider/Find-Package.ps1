function Find-Package { 
    param(
        [string[]] $Name,
        [string] $RequiredVersion,
        [string] $MinimumVersion,
        [string] $MaximumVersion
    )

	Write-Debug "In $($ProviderName)- Find-Package"
}