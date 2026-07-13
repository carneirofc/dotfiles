# Windows bootstrap: run from anywhere, paths resolve relative to this script.
# Requires an elevated shell (or Developer Mode) to create symbolic links.
$RepoRoot = Split-Path -Parent $PSScriptRoot

$hasPython = (Get-Command python -ErrorAction Ignore)
$hasLua = (Get-Command lua -ErrorAction Ignore)
$hasNode = (Get-Command node -ErrorAction Ignore)
$hasGit = (Get-Command git -ErrorAction Ignore)

function Install-Profile {
    if (Test-Path -Verbose -Path $PROFILE) {
        Remove-Item -Path $PROFILE
    }
    Copy-Item -Verbose -Path (Join-Path $PSScriptRoot 'profile.ps1') -Destination $PROFILE -Force
}

function Install-Neovim {
    $dest = Join-Path $RepoRoot 'common\nvim'   # cross-platform nvim config lives in common/
    New-Item -Verbose -Value $dest -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink
}

Install-Profile
Install-Neovim
