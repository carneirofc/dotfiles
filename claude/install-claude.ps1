# Install the Claude configs into %USERPROFILE%\.claude on Windows.
#
#   pwsh -File .\claude\install-claude.ps1
#
# Copies the agents/ and skills/ folders plus CLAUDE.md and AGENTS.md into
# ~/.claude. Everything is a plain copy: no symlinks, no elevation, no Developer
# Mode. Re-running is safe and refreshes every destination. Only files git
# tracks are copied, and nothing already in a destination is deleted: locally
# installed agents and skills survive, and a file removed from the repo stays
# behind until you delete it by hand.

# Stop at the first failed step instead of reporting success over it.
$ErrorActionPreference = 'Stop'

if (-not (Get-Command git -ErrorAction Ignore)) {
    throw 'git is required: configs are copied from the files git tracks.'
}

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

function Install-Tree {
    # Copy the files git tracks under $Source (a repo directory) into
    # $Destination, file by file. Nothing in $Destination is deleted.
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -Path $Source)) { return }
    $files = git -C $Source -c core.quotePath=false ls-files
    # Native commands don't honor $ErrorActionPreference; check the exit code.
    if ($LASTEXITCODE -ne 0) {
        throw "git ls-files failed in $Source"
    }
    foreach ($file in $files) {
        Install-File -Source (Join-Path $Source $file) -Destination (Join-Path $Destination $file)
    }
}

Install-Tree -Source (Join-Path $ClaudeSrc 'agents')    -Destination (Join-Path $ClaudeDest 'agents')
Install-Tree -Source (Join-Path $ClaudeSrc 'skills')    -Destination (Join-Path $ClaudeDest 'skills')
Install-File -Source (Join-Path $ClaudeSrc 'CLAUDE.md') -Destination (Join-Path $ClaudeDest 'CLAUDE.md')
Install-File -Source (Join-Path $ClaudeSrc 'AGENTS.md') -Destination (Join-Path $ClaudeDest 'AGENTS.md')

Write-Host "Claude configs installed into $ClaudeDest"
