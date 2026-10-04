# Install the Claude configs into %USERPROFILE%\.claude on Windows.
#
#   pwsh -File .\claude\install-claude.ps1
#
# Copies the agents/ and skills/ folders plus CLAUDE.md and AGENTS.md into
# ~/.claude. Everything is a plain copy: no symlinks, no elevation, no Developer
# Mode. Re-running is safe and refreshes every destination; stale destinations
# are removed first so upstream deletions propagate on re-run.
$ClaudeSrc = $PSScriptRoot
$ClaudeDest = if ($env:CLAUDE_HOME) { $env:CLAUDE_HOME } else { Join-Path $env:USERPROFILE '.claude' }

function Install-File {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -Path $Source)) { return }
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Verbose -Path $Source -Destination $Destination -Force
}

function Install-Dir {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -Path $Source)) { return }
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    # Remove a stale destination so upstream deletions propagate on re-run.
    if (Test-Path -Path $Destination) {
        Remove-Item -Path $Destination -Recurse -Force
    }
    Copy-Item -Verbose -Path $Source -Destination $Destination -Recurse -Force
}

Install-Dir  -Source (Join-Path $ClaudeSrc 'agents')    -Destination (Join-Path $ClaudeDest 'agents')
Install-Dir  -Source (Join-Path $ClaudeSrc 'skills')    -Destination (Join-Path $ClaudeDest 'skills')
Install-File -Source (Join-Path $ClaudeSrc 'CLAUDE.md') -Destination (Join-Path $ClaudeDest 'CLAUDE.md')
Install-File -Source (Join-Path $ClaudeSrc 'AGENTS.md') -Destination (Join-Path $ClaudeDest 'AGENTS.md')

Write-Host "Claude configs installed into $ClaudeDest"
