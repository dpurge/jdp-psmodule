---
external help file: JdpKeepass-help.xml
Module Name: JdpKeepass
schema: 2.0.0
---

# Get-JdpKeepassConfig

## SYNOPSIS
Returns configuration object.

## SYNTAX
```
Get-JdpKeepassConfig [[-Name] <String>] [[-Directory] <IO.DirectoryInfo>]
```

## DESCRIPTION
Description text is missing.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-JdpKeepassConfig
```

### -------------------------- EXAMPLE 2 --------------------------
```
Get-JdpKeepassConfig -Name MyPasswords -Directory (Join-Path $env:ProgramData Keepass)
```

## PARAMETERS

### -Name
Description missing.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: JdpKeepass
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Directory
Description missing.

```yaml
Type: IO.DirectoryInfo
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: (Split-Path -Path $Profile -Parent)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

