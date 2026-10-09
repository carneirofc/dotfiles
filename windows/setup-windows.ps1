# Windows bootstrap: run from anywhere, paths resolve relative to this script.
#
#   pwsh -File .\windows\setup-windows.ps1
#
# Installs the PowerShell profile and copies every config (nvim, wezterm,
# alacritty, zellij, git) plus the Claude agent/skill files into place.
# Re-running is safe and refreshes every destination. Only files git tracks are
# copied, and
# nothing already in a destination is deleted: local files there (installed
# skills, WezTerm backdrops) survive, and a file removed from the repo stays
# behind until you delete it by hand.
#
# Everything is a plain copy: no symlinks, no elevation, no Developer Mode.
# Runs on a locked-down/basic Windows account.

# Stop at the first failed step instead of reporting success over it.
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot

$hasPython = (Get-Command python -ErrorAction Ignore)
$hasLua = (Get-Command lua -ErrorAction Ignore)
$hasNode = (Get-Command node -ErrorAction Ignore)
$hasGit = (Get-Command git -ErrorAction Ignore)
if (-not $hasGit) {
    throw 'git is required: configs are copied from the files git tracks.'
}

# --- copy helpers -----------------------------------------------------------

function Install-File {
    param([string]$Source, [string]$Destination)
    $parent = Split-Path -Parent $Destination
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    Copy-Item -Verbose -Path $Source -Destination $Destination -Force
}

function Install-Tree {
    # Copy the files git tracks under $Source (a repo directory) into
    # $Destination, file by file. Untracked and ignored files in the checkout
    # (nvim/plugged, local tool state) are never deployed, and nothing in
    # $Destination is deleted.
    param([string]$Source, [string]$Destination)
    $files = git -C $Source -c core.quotePath=false ls-files
    # Native commands don't honor $ErrorActionPreference; check the exit code.
    if ($LASTEXITCODE -ne 0) {
        throw "git ls-files failed in $Source"
    }
    foreach ($file in $files) {
        Install-File -Source (Join-Path $Source $file) -Destination (Join-Path $Destination $file)
    }
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
    Install-Tree `
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
    Install-Tree `
        -Source (Join-Path $RepoRoot 'common\wezterm') `
        -Destination (Join-Path $env:USERPROFILE '.config\wezterm')
}

function Install-Zellij {
    # Native Windows Zellij uses the platform config dir, not ~/.config/zellij:
    # %APPDATA%\Zellij\config (verify with `zellij setup --check`). config.kdl and
    # the themes/ folder go directly there. %APPDATA%\zellij (lowercase, no
    # \config) is never read -- the theme/profile there goes undiscovered.
    $dest = Join-Path $env:APPDATA 'Zellij\config'
    $src = Join-Path $RepoRoot 'common\zellij'
    Install-File -Source (Join-Path $src 'config.kdl') -Destination (Join-Path $dest 'config.kdl')
    Install-Tree -Source (Join-Path $src 'themes')     -Destination (Join-Path $dest 'themes')
}

function Install-Git {
    # Git for Windows reads %USERPROFILE%\.config\git\{config,ignore} (XDG),
    # alongside any ~/.gitconfig. The credential helper needs gh on PATH.
    Install-Tree `
        -Source (Join-Path $RepoRoot 'common\git') `
        -Destination (Join-Path $env:USERPROFILE '.config\git')
}

function Install-Claude {
    # Delegate to the standalone claude installer so the copy logic lives in one
    # place (see claude/install-claude.ps1, which also runs on its own).
    & (Join-Path $RepoRoot 'claude\install-claude.ps1')
}

Install-Profile
Install-Neovim
Install-Alacritty
Install-Wezterm
Install-Zellij
Install-Git
Install-Claude
