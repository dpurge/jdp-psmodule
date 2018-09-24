$ErrorActionPreference = "Continue"
#requires -version 3

Import-Module ServiceRunner

$Scheduler = Get-ServiceScheduler `
    -Schedule stop-service `
    -ConfigFile $PSScriptRoot\Service.config
$Scheduler.Run()
