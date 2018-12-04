$ProviderName = "JdpSystem"
$PackageLocation = "${PsScriptRoot}\Packages"

Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object { . $_.FullName }
