#!/bin/bash
# Install Hyprland on an Arch-based distro.
#
# Usage: setup.bash          # Hyprland from the official repos
#        setup.bash --git    # the -git stack from the AUR (needs yay); replaces
#                            # the repo packages, don't mix the two
set -euo pipefail

command -v pacman >/dev/null || { echo "pacman not found; Arch-based distros only" >&2; exit 1; }

case ${1:-} in
"")
    sudo pacman -S --needed hyprland
    ;;
--git)
    command -v yay >/dev/null || { echo "--git needs yay (AUR helper)" >&2; exit 1; }
    yay -S --needed \
        ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 \
        libxcomposite libxrender libxcursor pixman wayland-protocols cairo pango libxkbcommon \
        xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus \
        hyprlang-git hyprcursor-git hyprwayland-scanner-git hyprwire-git xcb-util-errors \
        hyprutils-git glaze hyprgraphics-git aquamarine-git re2 hyprland-qtutils-git muparser \
        hyprland-git
    ;;
*)
    echo "usage: $(basename "$0") [--git]" >&2
    exit 1
    ;;
esac
