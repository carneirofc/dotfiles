$hasPython = (Get-Command python -ErrorAction Ignore)
$hasLua = (Get-Command lua -ErrorAction Ignore)
$hasNode = (Get-Command node -ErrorAction Ignore)
$hasGit = (Get-Command git -ErrorAction Ignore)

function Install-Profile {
    if (Test-Path -Verbose -Path $PROFILE) {
        Remove-Item -Path $PROFILE
    }
    Copy-Item -Verbose -Path ./windows/profile.ps1 -Destination $PROFILE -Force
}

function Install-Lua {
   ## Attempt to download and setup lua [http://luabinaries.sourceforge.net/download.html]
   #param([string]$dest = $env:USERPROFILE + "\apps")

   #if(-not(Test-Path -Path $dest)) {
   #    New-Item -Type Directory -Verbose -Path $dest
   #}

   #$locOriginal = Get-Location
   #Set-Location -Path $dest

   #Invoke-WebRequest -Verbose $urlBin -OutFile luaBin.zip
   #Invoke-WebRequest -Verbose $urlLib -OutFile luaLib.zip

   #Set-Location -Path $locOriginal
}
#Install-Lua

function Install-Neovim {
    $dest = (Get-Location).Path + "\nvim"
    New-Item -Verbose -Value $dest  -Path $env:USERPROFILE\AppData\Local\nvim -ItemType SymbolicLink 
}

Install-Profile
Install-Neovim
