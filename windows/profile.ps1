# Aliases
Function GitSatatus { & 'git' status @args }
Function GitDiff { & 'git' diff @args }
Function BfgRun { & 'java' -jar (Get-Command bfg.jar).Path @args }

Set-Alias -Name gits -Value GitSatatus
Set-Alias -Name gitd -Value GitDiff
Set-Alias -Name bfg  -Value BfgRun

# Unix-like tab completion
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Links, command line utilities
#
# https://github.com/BurntSushi/ripgrep/releases
# https://github.com/sharkdp/bat/releases
# https://github.com/neovide/neovide
# https://github.com/neovim/neovim
# https://github.com/tree-sitter/tree-sitter/releases (for nvim)

# Messing with the session path
$pathsToRemove = New-Object Collections.Generic.List[String]
$pathsToRemove.Add("C:\Program Files (x86)\Microsoft SDKs\TypeScript\1.0")

function ShouldSkip {
    param([string]$path)
    foreach ($remove in $pathsToRemove) {
        return $path.StartsWith($remove)
    }
}

function RemoveFromPath {
    param($list)
    foreach ($path in $Env:PATH.Split(";")) {
        if (ShouldSkip -path $path) { continue; }
        if ([String]::IsNullOrEmpty($path)) { continue; }

        $list.Add($path);
    }
}

function AddToPath {
    param($list)
    $appsPath = $env:USERPROFILE + "\apps"
    $list.Add($appsPath)
    $list.Add("$appsPath\lua")
    $list.Add("$appsPath\Neovim\bin")
    $list.Add("$appsPath\ripgrep-13.0.0-x86_64-pc-windows-msvc")
    $list.Add("$appsPath\bat-v0.21.0-x86_64-pc-windows-msvc")
    $list.Add("$appsPath\nvim-win64\bin")

    # https://github.com/nvim-treesitter/nvim-treesitter/wiki/Windows-support
    $list.Add("C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64")
}

function UpdatePath {
    $list = New-Object Collections.Generic.List[String]
    AddToPath -list $list
    RemoveFromPath -list $list
    $env:Path = [string]::Join(";", $list)
}
UpdatePath
