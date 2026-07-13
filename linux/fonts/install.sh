#!/bin/bash
set -exu
set -o pipefail

FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"
[ ! -f JetBrainsMono.zip ] && wget ${FONT_URL}
unzip -d jetbrains -o JetBrainsMono.zip
mkdir -p -v /usr/share/fonts/JetBrains
find jetbrains -type f ! -name "*Windows*" -name "*.ttf" -exec cp -v {} /usr/share/fonts/JetBrains \;
rm -rfv jetbrains JetBrainsMono.zip
