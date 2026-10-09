#!/usr/bin/env bash
# Copy a user's Plasma look into the Plasma Login Manager greeter, which runs
# as the 'plasmalogin' user and only sees its own copy of these files. Same
# set as System Settings > Login Screen > "Apply Plasma Settings", so colors,
# icons, fonts, cursor, keyboard layout and monitor setup match the session.
# The lock screen reads the user's files directly and needs none of this.
#
# Usage: sudo sync-login.sh <user-home> [wallpaper]
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "usage: sudo $(basename "$0") <user-home> [wallpaper]" >&2
    exit 1
fi
if [[ $EUID -ne 0 ]]; then
    echo "$(basename "$0"): must run as root" >&2
    exit 1
fi

src=$1/.config
greeter=/var/lib/plasmalogin
if ! id plasmalogin >/dev/null 2>&1; then
    echo "$(basename "$0"): no plasmalogin user; Plasma Login Manager isn't installed" >&2
    exit 1
fi

install -d -o plasmalogin -g plasmalogin "$greeter/.config"
for f in kdeglobals plasmarc kcminputrc kxkbrc kwinoutputconfig.json fontconfig/fonts.conf; do
    [[ -f $src/$f ]] || continue
    install -D -m 644 -o plasmalogin -g plasmalogin "$src/$f" "$greeter/.config/$f"
done
chown plasmalogin:plasmalogin "$greeter/.config/fontconfig" 2>/dev/null || true
# Cached icons and QML from the old theme would outlive the new config.
rm -rf "${greeter:?}/.cache"

if [[ $# -ge 2 ]]; then
    image=$(realpath "$2")
    dest="$greeter/wallpapers/$(basename "$image")"
    install -D -m 644 -o plasmalogin -g plasmalogin "$image" "$dest"
    kwriteconfig6 --file /etc/plasmalogin.conf \
        --group Greeter --group Wallpaper --group org.kde.image --group General \
        --key Image "file://$dest"
fi

echo "Login screen synced; it takes effect the next time the greeter starts."
