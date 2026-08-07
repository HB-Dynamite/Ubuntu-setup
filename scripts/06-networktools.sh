#!/usr/bin/env bash

set -Eeuo pipefail

# General VPN and remote-access tools.
sudo apt-get update
sudo apt-get install -y \
    curl \
    network-manager-openvpn-gnome \
    wireguard-tools \
    remmina

# Install eduVPN only if it is not already installed.
if dpkg-query -W eduvpn-client >/dev/null 2>&1; then
    echo "eduVPN is already installed."
else
    INSTALLER="$(mktemp --suffix=.sh)"
    trap 'rm -f "$INSTALLER"' EXIT

    echo "Downloading the official eduVPN installer..."
    curl --proto '=https' --tlsv1.2 -fsSL \
        https://docs.eduvpn.org/client/linux/install.sh \
        -o "$INSTALLER"

    echo "Installing eduVPN..."
    bash "$INSTALLER"
fi

echo
echo "Network tools installed successfully."