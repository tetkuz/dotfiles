# Requires Developer Mode ON, or run in an elevated PowerShell.
$ErrorActionPreference = 'Stop'
$repo = $PSScriptRoot

$links = [ordered]@{
  "$env:USERPROFILE\.gitconfig" = Join-Path $repo 'gitconfig'
  "$env:LOCALAPPDATA\nvim"      = Join-Path $repo 'config\nvim'
}

foreach ($pair in $links.GetEnumerator()) {
  $path   = $pair.Key
  $target = $pair.Value

  if (Test-Path -LiteralPath $path) {
    Remove-Item -LiteralPath $path -Recurse -Force
  }
  $parent = Split-Path -Parent $path
  if (-not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  New-Item -ItemType SymbolicLink -Path $path -Target $target | Out-Null
  Write-Host "linked: $path -> $target"
}
