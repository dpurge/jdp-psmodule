function Get-JdpSystemInfo {

	[OutputType('JdpSystem.Info')]
	[CmdletBinding()]
    param ()

	# ---------- ---------- ---------- ---------- ----------

	$Info = New-Object PSCustomObject -Property @{
		Timestamp = $null
		Variable  = @{}
		Directory = @{}
		Path = @{}
	}
	$Info.PSTypeNames.Insert(0, 'JdpSystem.Info')

	# ---------- ---------- ---------- ---------- ----------

	Add-Member `
        -InputObject $Info `
        -MemberType ScriptMethod `
        -Name Refresh `
        -Value `
    {
        param ()
        
		$this.Timestamp = Get-Date

		$Root = if ($Env:JdpSystem_Home) { $Env:JdpSystem_Home } else { Join-Path -Path $Env:SystemDrive -ChildPath 'jdp' }

		$this.Directory.Root = [IO.DirectoryInfo] $Root
		$this.Directory.Binaries = [IO.DirectoryInfo] "${Root}\bin"
		$this.Directory.Configuration = [IO.DirectoryInfo] "${Root}\cfg"
		$this.Directory.Data = [IO.DirectoryInfo] "${Root}\dat"
		$this.Directory.Documents = [IO.DirectoryInfo] "${Root}\doc"
		$this.Directory.Programs = [IO.DirectoryInfo] "${Root}\pgm"
		$this.Directory.Sources = [IO.DirectoryInfo] "${Root}\src"
		$this.Directory.Temporary = [IO.DirectoryInfo] "${Root}\tmp"

		$Choco = if ($Env:ChocolateyInstall) { $Env:ChocolateyInstall } else { Join-Path -Path $this.Directory.Programs.FullName -ChildPath 'chocolatey' }

		$this.Variable.Home = @{
			Name = 'JdpSystem_Home'
			Value = $Root
			Exists = [bool]($Env:JdpSystem_Home)
		}

		$this.Variable.Chocolatey = @{
			Name = 'ChocolateyInstall'
			Value = $Choco
			Exists = [bool]($Env:ChocolateyInstall)
		}

		$Path = $Env:Path.Split(';')

		$this.Path.Binaries = @{
			Value = $this.Directory.Binaries.FullName
			Exists = $Path -contains $this.Directory.Binaries.FullName
		}
    }

	# ---------- ---------- ---------- ---------- ----------

	$Info.Refresh()
	return $Info
}