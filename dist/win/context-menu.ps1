<#
.SYNOPSIS
    Adds (or removes) a "Analizar con Spek-X" entry to the Windows Explorer
    right-click menu of every file.

.DESCRIPTION
    The entry runs:  spek.exe "<selected file>"
    Spek-X then opens the file and starts the analysis right away.

    The entry is written under HKEY_CURRENT_USER, so no administrator rights
    are needed and it only affects the current user.

    Windows 11 shows it under "Show more options" (Shift+F10).

.PARAMETER ExePath
    Full path to spek.exe. Defaults to the spek.exe next to this script.

.PARAMETER Label
    Text shown in the context menu.

.PARAMETER Uninstall
    Remove the entry instead of adding it.
#>
[CmdletBinding()]
param(
    [string]$ExePath = (Join-Path $PSScriptRoot 'spek.exe'),
    [string]$Label = 'Analizar con Spek-X',
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

# '*' means "every file". The registry is accessed through .NET because the
# PowerShell registry provider would treat the '*' as a wildcard.
$subKey = 'Software\Classes\*\shell\SpekX'
$hkcu = [Microsoft.Win32.Registry]::CurrentUser

if ($Uninstall) {
    $hkcu.DeleteSubKeyTree($subKey, $false)
    Write-Host 'Menu contextual de Spek-X eliminado.'
    return
}

if (-not (Test-Path -LiteralPath $ExePath -PathType Leaf)) {
    throw "No se encontro spek.exe en '$ExePath'. Use -ExePath para indicar la ruta."
}
$exe = (Resolve-Path -LiteralPath $ExePath).ProviderPath

$key = $hkcu.CreateSubKey($subKey)
$key.SetValue('', $Label)
$key.SetValue('Icon', "`"$exe`",0")
$cmd = $key.CreateSubKey('command')
$cmd.SetValue('', "`"$exe`" `"%1`"")
$cmd.Close()
$key.Close()

Write-Host "Menu contextual instalado: '$Label' -> $exe"
