---
external help file: JdpKeepass-help.xml
Module Name: JdpKeepass
schema: 2.0.0
---

# New-JdpKeepassConfig

## SYNOPSIS
Generates new configuration file with default contents.

## SYNTAX
```
New-JdpKeepassConfig [[-Name] <String>] [[-Directory] <IO.DirectoryInfo>]
```

## DESCRIPTION
Description text is missing.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
New-JdpKeepassConfig
```

### -------------------------- EXAMPLE 2 --------------------------
```
New-JdpKeepassConfig -Name MyPasswords -Directory (Join-Path $env:ProgramData Keepass)
```
