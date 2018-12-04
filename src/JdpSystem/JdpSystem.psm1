$ErrorActionPreference = "Stop"
#requires -version 5

$script:PackageRegistryFile = "{CONFIGURATION-DIRECTORY}\system\PackageRegistry.json"

Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object { . $_.FullName }
