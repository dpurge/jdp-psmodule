$ErrorActionPreference = "Stop"
#requires -version 5

Get-ChildItem -Path $PSScriptRoot\*.ps1 | Foreach-Object { . $_.FullName }