#!/bin/bash
set -exu -o pipefail
if [[ -f /etc/debian_version ]]; then
    apt-get install ripgrep
else
    echo "ripgrep must be installed manually https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz"
    exit 1
fi
