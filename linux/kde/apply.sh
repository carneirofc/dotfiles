#!/usr/bin/env bash
# Opinionated KDE Plasma 6 look, applied key by key with kwriteconfig6 so the
# rest of each rc file (which Plasma rewrites at runtime) is left alone.
# Colors come from matugen (linux/matugen/set-wallpaper.sh), not from here.
set -euo pipefail

kw() { kwriteconfig6 "$@"; }
has_effect() {
    qdbus6 org.kde.KWin /Effects org.kde.kwin.Effects.listOfEffects 2>/dev/null | grep -qx "$1"
}

# Global theme stays Breeze Dark; widgets and Plasma style follow the color scheme.
kw --file kdeglobals --group KDE --key LookAndFeelPackage org.kde.breezedark.desktop
kw --file kdeglobals --group KDE --key widgetStyle Breeze
kw --file plasmarc --group Theme --key name default

# The accent is the scheme's selection color (matugen primary), so don't let
# Plasma override it with its own wallpaper/custom accent.
kw --file kdeglobals --group General --key accentColorFromWallpaper false
kw --file kdeglobals --group General --key AccentColor --delete

# Icons: Papirus-Dark when installed (pacman -S papirus-icon-theme), else Breeze.
icons=breeze-dark
[[ -d /usr/share/icons/Papirus-Dark ]] && icons=Papirus-Dark
kw --file kdeglobals --group Icons --key Theme "$icons"
# Notify running apps too; the kdeglobals key alone needs a re-login.
/usr/lib/plasma-changeicons "$icons" >/dev/null 2>&1 || true

# Frosted translucency behind panels, menus and translucent windows.
kw --file kwinrc --group Plugins --key blurEnabled true
kw --file kwinrc --group Plugins --key contrastEnabled true
kw --file kwinrc --group Effect-blur --key BlurStrength 10
kw --file kwinrc --group Effect-blur --key NoiseStrength 4

# Breeze window decorations: borderless, centered titles, no outline.
kw --file kwinrc --group org.kde.kdecoration2 --key BorderSize None
kw --file kwinrc --group org.kde.kdecoration2 --key BorderSizeAuto false
kw --file breezerc --group Common --key OutlineIntensity OutlineOff
kw --file breezerc --group Windeco --key TitleAlignment AlignCenterFullWidth

# Rounded window corners (pacman -S kwin-effect-rounded-corners).
if has_effect kwin4_effect_shapecorners; then
    kw --file kwinrc --group Plugins --key kwin4_effect_shapecornersEnabled true
fi

qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
echo "KDE settings applied; log out and back in if panels look stale."
