$psake.use_exit_on_error = $true
$config = & .\build.config.ps1

properties {
    # Source code management
    $CurrentDir = Resolve-Path .
    $BaseDir = $psake.build_script_dir
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
	
	$SourceDir = "$BaseDir\src"
	$OutputDir = "$BaseDir\out"
	$TempDir   = "$BaseDir\tmp"
	$PackageDir   = "$BaseDir\.nuget"

    #$version = git.exe describe --abbrev=0 --tags

    # Parameters
    $Modules = if ($config.ContainsKey('Modules')) { $config['Modules'] } else { Get-ChildItem -Path $SourceDir | ?{ $_.PSIsContainer } | Select-Object -ExpandProperty Name }
    $Version = if ($config.ContainsKey('Version')) { $config['Version'] } else { '' }
	$NugetExe = if ($config.ContainsKey('NugetExe')) { $config['NugetExe'] } else { 'nuget' }
	$NugetSource = if ($config.ContainsKey('NugetSource')) { $config['NugetSource'] } else { $null }
	$NuGetApiKey = if ($config.ContainsKey('NuGetApiKey')) { $config['NuGetApiKey'] } else { $null }
}

Import-Module platyPS

Task default -depends Build

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task GenerateVersion `
    -description "Generate version string" `
    -requiredVariable Version `
{
    if ([String]::IsNullOrWhiteSpace($Version))
    {
        Write-Host -NoNewline "`tGenerating version: "
        $Timestamp = Get-Date
        $VersionBuilder = New-Object System.Text.StringBuilder
        [void] $VersionBuilder.Append($Timestamp.Year)
        [void] $VersionBuilder.Append('.')
        [void] $VersionBuilder.Append($Timestamp.Month)
        [void] $VersionBuilder.Append('.')
        [void] $VersionBuilder.Append($Timestamp.Day)
        $script:Version = $VersionBuilder.ToString()
    }
    else
    {
        Write-Host -NoNewline "`tUsing version: "
        $script:Version = $Version.Trim()
    }
    Write-Host $script:Version
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task CreateDirectory `
    -description "Create temporary directories" `
    -requiredVariable TempDir, OutputDir `
{
    # Create temp directory if it does not exist
    if (-not (Test-Path -Path $TempDir -PathType Container))
    {
        Write-Host "`tCreating directory: $TempDir"
        New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
    }

    # Create output directory if it does not exist
    if (-not (Test-Path -Path $OutputDir -PathType Container))
    {
        Write-Host "`tCreating directory: $OutputDir"
        New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
    }
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task RestoreNuget `
    -description "Restore nuget dependencies" `
    -requiredVariable BaseDir, NugetExe, PackageDir `
{
    Push-Location $BaseDir
	Write-Host "Restoring nuget packages..."
	Exec {
		#& $NugetExe restore -PackagesDirectory $PackageDir
		& $NugetExe install -OutputDirectory $PackageDir -ExcludeVersion
	}
	Pop-Location
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task SetPsModulePath `
    -description "Configure PSModulePath to import from temporary directory" `
    -requiredVariable TempDir `
{
    if ($Env:PSModulePath.Split(';') -notcontains $TempDir) {
	    Write-Host "Adding to PSModulePath: $TempDir"
	    $Env:PSModulePath = $TempDir+ ';' + $Env:PSModulePath
	}
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Clean `
    -description "Remove temporary artifacts" `
    -requiredVariable TempDir, OutputDir `
{
	if (Test-Path $TempDir) {
		Write-Host "Removing directory: $TempDir"
		Remove-Item $TempDir -Force -Recurse
	}
	if (Test-Path $OutputDir) {
		Write-Host "Removing directory: $OutputDir"
		Remove-Item $OutputDir -Force -Recurse
	}
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Build `
    -description "Build powershell modules" `
    -depends RestoreNuget, GenerateVersion, CreateDirectory `
    -requiredVariable SourceDir, TempDir, Version, Modules `
{
    foreach ($module in $Modules)
    {
        Write-Host "`tBuilding module: $module"
		
		$ModuleSourceDir = "$SourceDir\$module"
		$ModuleOutputDir = "$TempDir\$module"
		$ModuleOutputPsd1 = '{0}\{1}.psd1' -F $ModuleOutputDir, $module
		$ModuleNuspec = "$TempDir\$module.nuspec"
		$ModuleReleaseNotes = @"
Date of release: $(Get-Date)
Source repository URI: MISSING
Source branch: MISSING
Source version: MISSING
"@
		
		if (Test-Path $ModuleNuspec) {
		    Write-Host "Removing nuspec file: $ModuleNuspec"
			Remove-Item $ModuleNuspec -Force
		}
		
		if (Test-Path $ModuleOutputDir) {
		    Write-Host "Removing directory: $ModuleOutputDir"
			Remove-Item $ModuleOutputDir -Force -Recurse
		}
		
		Write-Host "`tCreating directory: $ModuleOutputDir"
        New-Item -ItemType Directory -Force -Path $ModuleOutputDir | Out-Null
		
		Copy-Item -Path $ModuleSourceDir\* -Destination $ModuleOutputDir\ -Recurse -Exclude *.Tests.ps1, docs
		(Get-Content $ModuleOutputPsd1) -replace "ModuleVersion\s*=\s*'\d(\.\d)+'", "ModuleVersion = '${script:Version}'" | Set-Content $ModuleOutputPsd1
		if (Test-Path "$ModuleSourceDir\docs") {
            foreach ($DocsDir in (Get-ChildItem -Path "$ModuleSourceDir\docs" | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty Name)) {
			    Write-Host "Generating documentation: $ModuleOutputDir\$DocsDir"
                New-ExternalHelp "$ModuleSourceDir\docs\$DocsDir" -OutputPath "$ModuleOutputDir\$DocsDir" | Out-Null
            }
		}
		
		Write-Host "Creating nuspec file: $ModuleNuspec"
		Import-LocalizedData -BaseDirectory $ModuleOutputDir -FileName "$Module.psd1" -BindingVariable ModuleData
		
		
		Push-Location $TempDir
		$ModuleFiles = Get-ChildItem $ModuleOutputDir -recurse | Where-Object { -not $_.PSIsContainer } | ForEach-Object {Resolve-Path $_.FullName -Relative}
		Pop-Location
		
		$NuSpecWriter = New-Object System.XMl.XmlTextWriter($ModuleNuspec, $Null)
		$NuSpecWriter.Formatting = 'Indented'
		$NuSpecWriter.Indentation = 2
		$NuSpecWriter.IndentChar = " "
		$NuSpecWriter.WriteStartDocument()
		$NuSpecWriter.WriteStartElement('package')
		$NuSpecWriter.WriteAttributeString('xmlns', 'http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd')
		
		$NuSpecWriter.WriteStartElement('metadata')
		$NuSpecWriter.WriteElementString('id', $ModuleData.RootModule)
		$NuSpecWriter.WriteElementString('version', $ModuleData.ModuleVersion)
		$NuSpecWriter.WriteElementString('authors', $ModuleData.Author)
		$NuSpecWriter.WriteElementString('owners', $ModuleData.CompanyName)
		if ($ModuleData.PrivateData.PSData.LicenseUri) {
		    $NuSpecWriter.WriteElementString('licenseUrl', $ModuleData.PrivateData.PSData.LicenseUri)
		}
		if ($ModuleData.PrivateData.PSData.ProjectUri) {
		    $NuSpecWriter.WriteElementString('projectUrl', $ModuleData.PrivateData.PSData.ProjectUri)
		}
		if ($ModuleData.PrivateData.PSData.IconUri) {
		    $NuSpecWriter.WriteElementString('iconUrl', $ModuleData.PrivateData.PSData.IconUri)
		}
		$NuSpecWriter.WriteElementString('requireLicenseAcceptance','false')
		$NuSpecWriter.WriteElementString('description', $ModuleData.Description)
		$NuSpecWriter.WriteElementString('tags', ($ModuleData.PrivateData.PSData.Tags -join ', '))
		$NuSpecWriter.WriteElementString('releaseNotes', $ModuleReleaseNotes)
		$NuSpecWriter.WriteEndElement()
		
		$NuSpecWriter.WriteStartElement('files')
		foreach ($ModuleFile in $ModuleFiles) {
			$NuSpecWriter.WriteStartElement('file')
			$NuSpecWriter.WriteAttributeString('src', $ModuleFile)
			$NuSpecWriter.WriteAttributeString('target', ($ModuleFile -replace "$module\\", ''))
			$NuSpecWriter.WriteEndElement()
		}
		$NuSpecWriter.WriteEndElement()
		
		$NuSpecWriter.WriteEndElement()
		$NuSpecWriter.WriteEndDocument()
		$NuSpecWriter.Flush()
		$NuSpecWriter.Close()
    }
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Test `
    -description "Execute unit tests" `
    -depends Build, SetPsModulePath `
    -requiredVariable SourceDir, TempDir, Modules `
{
    if (-not (Get-Command Invoke-Pester)) { throw "Cannot test, command does not exist: Invoke-Pester" }
	
    foreach ($module in $Modules)
    {
        $ModuleTestDir = Join-Path -Path $SourceDir -ChildPath $module
        $ModuleTestOutput = Join-Path -Path $TempDir -ChildPath "${module}.Tests.xml"
		Write-Host "Results of unit tests for module '${module}': ${ModuleTestOutput}"
        Invoke-Pester -EnableExit -OutputFile $ModuleTestOutput -OutputFormat NUnitXml $ModuleTestDir
    }
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Package `
    -description "Create nuget packages" `
    -depends Build `
    -requiredVariable TempDir, OutputDir, Modules, NugetExe `
{
    if (-not (Get-Command $NugetExe)) { throw "Cannot package, command does not exist: ${NugetExe}" }
	
	Push-Location $TempDir
    foreach ($Module in $Modules) {
	    Write-Host "Generating nupkg for module: $Module"
		Exec {
			& $NugetExe pack "$Module.nuspec" -OutputDirectory $OutputDir -NoPackageAnalysis -NoDefaultExcludes
		}
    }
	Pop-Location
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Deploy `
    -description "Push nuget packages to the repository" `
    -depends Package `
    -requiredVariable OutputDir, Modules, Version, NugetSource, NuGetApiKey `
{
    foreach ($Module in $Modules) {
	    $NugetFile = Join-Path -Path $OutputDir -ChildPath "${Module}.${script:Version}.nupkg"
	    Write-Host "Publishing nuget file: $NugetFile"
		if (-not (Test-Path $NugetFile)) {throw "File does not exist: $NugetFile"}
		Exec {
			& $NugetExe push $NugetFile -ApiKey $NuGetApiKey -Source $NugetSource -Verbosity detailed
		}
    }
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Install `
    -description "Install powershell modules on the local system" `
    -depends Package `
    -requiredVariable OutputDir, Modules, Version `
{
    foreach ($Module in $Modules) {
	    $NugetFile = Join-Path -Path $OutputDir -ChildPath "${Module}.${script:Version}.nupkg"
	    Write-Host "Installing powershell module $Module from: $NugetFile"
		if (-not (Test-Path $NugetFile)) { throw "File does not exist: $NugetFile" }
		Exec {
			Install-Module -Name $Module -RequiredVersion $script:Version -Repository $OutputDir -Force
		}
    }
}

# ---------- # ---------- # ---------- # ---------- # ---------- #

Task Run `
    -description "Run console with modules imported" `
    -depends Build, SetPsModulePath `
    -requiredVariable TempDir, Modules `
{
	$InitScriptBuilder = New-Object -TypeName System.Text.StringBuilder
	$InitScriptBuilder.Append('& {')
	foreach ($module in $Modules) {
		$InitScriptBuilder.Append("Import-Module -Force $(Join-Path $TempDir $module);")
	}
	$InitScriptBuilder.Append('}')
	$InitScript = $InitScriptBuilder.ToString()
	
	Start-Process -FilePath powershell.exe -WorkingDirectory $TempDir -ArgumentList @('-NoExit', '-Command', $InitScript)
}
