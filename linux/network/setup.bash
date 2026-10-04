#!/bin/bash
set -eu -o pipefail

# Install the NetworkManager Wi-Fi power-save drop-in into /etc and reload
# NetworkManager. Needs root, so it re-execs itself under sudo.
# Works regardless of the current working directory.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
conf_dir="/etc/NetworkManager/conf.d"
conf_name="wifi-powersave.conf"

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Installing into $conf_dir requires root, re-running under sudo"
    # Absolute path: sudo may not preserve the cwd a relative $0 would need.
    exec sudo -- "$script_dir/$(basename "${BASH_SOURCE[0]}")" "$@"
fi

# /etc is outside the repo, so copy rather than symlink — a symlink into a home
# directory breaks if the repo moves or the user's home isn't mounted at boot.
install -v -D -m 0644 "$script_dir/$conf_name" "$conf_dir/$conf_name"

systemctl reload NetworkManager

echo
echo "Wi-Fi power save disabled. Verify with:"
echo "  iw dev <iface> get power_save    # expect: Power save: off"
echo
echo "Power save is only half the fix for a link that stalls. If the kernel log"
echo "shows repeated 'disconnect from AP ... for new auth to ...' lines, the card"
echo "is ping-ponging between two BSSIDs of the same SSID — pin it to one radio:"
echo "  nmcli connection modify <name> 802-11-wireless.bssid <BSSID>"
echo "See the Wi-Fi stability section of the README."
