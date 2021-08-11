#!/bin/sh
set -exu
[ ! -f JetBrainsMono.zip ] && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip -o -v -d jetbrains JetBrainsMono.zip
sudo mkdir -p -v /usr/share/fonts/JetBrains

sudo find jetbrains -type f ! -name "*Windows*" -name "*.ttf" -exec cp -v {} /usr/share/fonts/JetBrains \;
rm -rfv jetbrains

