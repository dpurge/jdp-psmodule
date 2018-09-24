$ErrorActionPreference = "Continue"
#requires -version 3

Import-Module ServiceRunner
Import-Module ServiceJob

# ... or ...
# Get-ChildItem $PSScriptRoot `
#     | ?{ $_.PSIsContainer } `
#     | %{Import-Module ("{0}\{1}" -F $PSScriptRoot,$_.Name)}

$Service = Get-ServiceMain -ConfigFile $PSScriptRoot\Service.config
$Service.Run()