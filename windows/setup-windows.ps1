# Windows bootstrap: run from anywhere, paths resolve relative to this script.
#
#   pwsh -File .\windows\setup-windows.ps1
#
# Installs the PowerShell profile and copies every config (nvim, wezterm,
# alacritty, zellij) plus the Claude agent/skill files into place. Re-running is
# safe and refreshes every destination.
#
# Everything is a plain copy: no symlinks, no elevation, no Developer Mode.
# Runs on a locked-down/basic Windows account.
$RepoRoot = Split-Path -Parent $PSScriptRoot

$hasPython = (Get-Command python -ErrorAction Ignore)
$hasLua = (Get-Command lua -ErrorAction Ignore)
$hasNode = (Get-Command node -ErrorAction Ignore)
$hasGit = (Get-Command git -ErrorAction Ignore)

# --- copy helpers -----------------------------------------------------------

function Install-File {
    param([string]$Source, [string]$Destination)
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Verbose -Path $Source -Destination $Destination -Force
}

function Install-Dir {
    param([string]$Source, [string]$Destination)
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

# --- install steps ----------------------------------------------------------

function Install-Profile {
    if (Test-Path -Verbose -Path $PROFILE) {
        Remove-Item -Path $PROFILE
    }
    Install-File -Source (Join-Path $PSScriptRoot 'profile.ps1') -Destination $PROFILE
}

function Install-Neovim {
    # cross-platform nvim config lives in common/; copied (not symlinked) so no
    # elevation / Developer Mode is required. Neovim reads %LOCALAPPDATA%\nvim.
    Install-Dir `
        -Source (Join-Path $RepoRoot 'common\nvim') `
        -Destination (Join-Path $env:LOCALAPPDATA 'nvim')
}

function Install-Alacritty {
    # Windows Alacritty reads %APPDATA%\alacritty\alacritty.toml
    Install-File `
        -Source (Join-Path $PSScriptRoot 'alacritty\alacritty.toml') `
        -Destination (Join-Path $env:APPDATA 'alacritty\alacritty.toml')
}

function Install-Wezterm {
    # WezTerm reads %USERPROFILE%\.config\wezterm\wezterm.lua. The config is
    # cross-platform, so it is shared from common/.
    Install-Dir `
        -Source (Join-Path $RepoRoot 'common\wezterm') `
        -Destination (Join-Path $env:USERPROFILE '.config\wezterm')
}

function Install-Zellij {
    # Native Windows Zellij uses the platform config dir, not ~/.config/zellij:
    # %APPDATA%\Zellij\config (verify with `zellij setup --check`). config.kdl and
    # the themes/ folder go directly there. %APPDATA%\zellij (lowercase, no
    # \config) is never read -- the theme/profile there goes undiscovered.
    $dest = Join-Path $env:APPDATA 'Zellij\config'
    Install-File -Source (Join-Path $PSScriptRoot 'zellij\config.kdl') -Destination (Join-Path $dest 'config.kdl')
    Install-Dir  -Source (Join-Path $PSScriptRoot 'zellij\themes')     -Destination (Join-Path $dest 'themes')
}

function Install-Claude {
    $claudeSrc = Join-Path $RepoRoot 'claude'
    $claudeDest = Join-Path $env:USERPROFILE '.claude'

    Install-Dir `
        -Source (Join-Path $claudeSrc 'agents') `
        -Destination (Join-Path $claudeDest 'agents')

    $skills = Join-Path $claudeSrc 'skills'
    if (Test-Path -Path $skills) {
        Install-Dir -Source $skills -Destination (Join-Path $claudeDest 'skills')
    }

    foreach ($f in 'CLAUDE.md', 'AGENTS.md') {
        $src = Join-Path $claudeSrc $f
        if (Test-Path -Path $src) {
            Install-File -Source $src -Destination (Join-Path $claudeDest $f)
        }
    }
}

Install-Profile
Install-Neovim
Install-Alacritty
Install-Wezterm
Install-Zellij
Install-Claude
