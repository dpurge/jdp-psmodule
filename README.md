# jdp-psmodule

This is the 'jdp-psmodule' project.

This project builds powershell modules.


## Build dependencies

This project uses Psake as its build system, Pester to run tests, PlatyPS to generate module documentation and nuget to package the modules.

Install them like so:

```
Install-Module psake
Install-Module Pester
Install-Module PlatyPS
choco install NuGet.CommandLine
```

This project is configured to be used with [Visual Studio Code](https://code.visualstudio.com/Download).

You can install it like so:

```
choco install visualstudiocode
```


## Adding modules to the source code

Use `warmup` in the terminal window to add new powershell modules to the source code:

```
cd src
warmup psmodule NewModule
```

Warmup must be configured on your system so that it can find the `psmodule` template.

## Managing powershell module repositories

Here are example commands for managing local powershell module repositories:

```
Register-PSRepository -Name LocalNugetRepo -SourceLocation C:\nupkg -InstallationPolicy Trusted
Unregister-PSRepository LocalNugetRepo
Get-PSRepository
```

Here is the example showing how to work with  Nuget Server based repositories:

```
Register-PSRepository -Name "LocalNugetRepo" ?SourceLocation "http://nuget.example.com/api/v2/" -PublishLocation "http://nuget.example.com/api/v2/package/" -InstallationPolicy Trusted
```

## Usage of the build project

The build tasks can be called either from command line or from Visual Studio Code.

Build parameters can be overwritten by one of the three ways:

- Adding a key to `build.config.ps1`.
  This file should not be added to the source control and should be used for parameters that cannot be committed to the source control.
- Adding a key in the `-properties` argument in the respective task in the `.vscode\tasks.json` file.
  This way should only be used for tasks added for a specific purpose, like building a subset of modules.
- Overriding a property on the command line.
  This way is a good match for continuous build systems to pass secret values or modify build properties in a way that cannot be committed to the source code.

### Build modules

From command line: `Invoke-PSake build.psake.ps1`

From Visual Studio Code: press `Ctrl+Shift+B`.

### Run unit tests

From command line: `Invoke-PSake build.psake.ps1 -Task Test`

From Visual Studio Code: press `F1`, type `run task`, choose `Test`.

### Package modules

From command line: `Invoke-PSake build.psake.ps1 -Task Package`

From Visual Studio Code: press `F1`, type `run task`, choose `Package`.

### Publish modules

From command line: `Invoke-PSake build.psake.ps1 -Task Publish`

From Visual Studio Code: press `F1`, type `run task`, choose `Publish`.

### Install locally

This operation should be done with Administrative access rights.

From command line: `Invoke-PSake build.psake.ps1 -Task Install`

From Visual Studio Code: press `F1`, type `run task`, choose `Install`.

### Start console with modules imported

From command line: `Invoke-PSake build.psake.ps1 -Task Run`

From Visual Studio Code: press `F1`, type `run task`, choose `Run`.

### Clean up project

From command line: `Invoke-PSake build.psake.ps1 -Task Clean`

From Visual Studio Code: press `F1`, type `run task`, choose `Clean`.