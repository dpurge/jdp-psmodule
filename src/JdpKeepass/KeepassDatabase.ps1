class KeepassDatabase {

	[KeePassLib.Interfaces.NullStatusLogger] $StatusLogger 
	[KeePassLib.Serialization.IOConnectionInfo] $IOConnectionInfo
	[KeePassLib.Keys.CompositeKey] $CompositeKey
	[KeePassLib.Keys.KcpUserAccount] $KcpUserAccount
	[KeePassLib.PwDatabase] $PwDatabase
	
	KeepassDatabase([IO.FileInfo] $File) {
		$this.StatusLogger = New-Object KeePassLib.Interfaces.NullStatusLogger
		$this.IOConnectionInfo = New-Object KeePassLib.Serialization.IOConnectionInfo
		$this.CompositeKey = New-Object -TypeName KeePassLib.Keys.CompositeKey
		$this.KcpUserAccount = New-Object -TypeName KeePassLib.Keys.KcpUserAccount
		$this.PwDatabase = New-Object -TypeName KeePassLib.PwDatabase
		$this.IOConnectionInfo.Path = $File.FullName
		$this.CompositeKey.AddUserKey( $this.KcpUserAccount )
	}
	
	Open() {
		$this.PwDatabase.Open($this.IOConnectionInfo, $this.CompositeKey, $this.StatusLogger)
	}
	
	Close() {
	    $this.PwDatabase.Close()
	}
	
	Save() {
		$this.PwDatabase.Save($this.StatusLogger)
	}
	
	Add(
		[string] $Title,
		[string] $UserName,
		[string] $Password,
		[string] $Group,
		[string] $URL,
		[string] $Note)
	{		
		$PwGroup = $Null
		
		if ($group) {
		    $PwGroup = $this.PwDatabase.RootGroup.Groups | Where { $_.Name -eq $Group } | Select-Object -First 1
			if (-not $PwGroup) {
			    $PwGroup = New-Object -TypeName KeePassLib.PwGroup
				$PwGroup.Name = $Group
				$this.PwDatabase.RootGroup.AddGroup($PwGroup, $True)
			}
		} else {
		    $PwGroup = $this.PwDatabase.RootGroup[0]
		}
		
		$PwEntry = $PwGroup.GetEntries($True) | Where { $_.Strings.ReadSafe("Title") -eq $Title } | Select-Object -First 1
		
		if (-not $PwEntry) {
		    $PwEntry = New-Object -TypeName KeePassLib.PwEntry -ArgumentList $PwGroup, $True, $True
			$pTitle = New-Object KeePassLib.Security.ProtectedString($True, $Title)
			$PwEntry.Strings.Set("Title", $pTitle)
		    $PwGroup.AddEntry($PwEntry, $True)
		}

		$pUser = New-Object KeePassLib.Security.ProtectedString($True, $UserName)
		$pPW = New-Object KeePassLib.Security.ProtectedString($True, $Password)
		$pURL = New-Object KeePassLib.Security.ProtectedString($True, $URL)
		$pNotes = New-Object KeePassLib.Security.ProtectedString($True, $Note)

		$PwEntry.Strings.Set("UserName", $pUser)
		$PwEntry.Strings.Set("Password", $pPW)
		$PwEntry.Strings.Set("URL", $pURL)
		$PwEntry.Strings.Set("Notes", $pNotes)
		
	}
	
	[Hashtable] Get(
	    [string] $Title,
		[string] $Group)
	{	
		$PwGroup = $Null
		
		if ($group) {
		    $PwGroup = $this.PwDatabase.RootGroup.Groups | Where { $_.Name -eq $Group } | Select-Object -First 1
			if (-not $PwGroup) {
			    throw "Group not found in Keepass file: $Group"
			}
		} else {
		    $PwGroup = $this.PwDatabase.RootGroup
		}
		
		$PwEntry = $PwGroup.GetEntries($True) | Where { $_.Strings.ReadSafe("Title") -eq $Title } | Select-Object -First 1
		
		if (-not $PwEntry) {
		    throw "No entry found with title: $Title"
		}
	
	    return @{
		    Group = $PwGroup.Name;
		    Title = $PwEntry.Strings.ReadSafe("Title");
		    Username = $PwEntry.Strings.ReadSafe("UserName");
		    Password = $PwEntry.Strings.ReadSafe("Password");
		    Url = $PwEntry.Strings.ReadSafe("Url");
		    Note = $PwEntry.Strings.ReadSafe("Note");
		}
	}
}