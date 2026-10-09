#!/usr/bin/env bash
# Set the KDE Plasma wallpaper (desktop + lock screen) and regenerate the
# matugen palette for every themed app from it.
#
# Usage: set-wallpaper.sh <image> [extra matugen args, e.g. -t scheme-content]
#        MATUGEN_MODE=light set-wallpaper.sh <image>   # default: dark
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "usage: $(basename "$0") <image> [matugen args...]" >&2
    exit 1
fi

image=$(realpath "$1")
shift
config_dir=$(dirname "$(realpath "$0")")

plasma-apply-wallpaperimage "$image"
kwriteconfig6 --file kscreenlockerrc \
    --group Greeter --group Wallpaper --group org.kde.image --group General \
    --key Image "file://$image"

# --source-color-index 0 picks the dominant color without the interactive prompt.
# The mode comes from MATUGEN_MODE: matugen rejects a second --mode in "$@".
matugen image "$image" \
    --config "$config_dir/config.toml" \
    --mode "${MATUGEN_MODE:-dark}" \
    --source-color-index 0 \
    "$@"
