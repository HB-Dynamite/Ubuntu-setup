#!/usr/bin/env bash

set -Eeuo pipefail

# Temporary directory for downloaded DEB files.
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

install_brave() {
    if command -v brave-browser >/dev/null 2>&1; then
        echo "Brave Browser is already installed."
        return
    fi

    echo "Adding the official Brave repository..."

    sudo curl -fsSLo \
        /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

    sudo curl -fsSLo \
        /etc/apt/sources.list.d/brave-browser-release.sources \
        https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

    sudo apt-get update
    sudo apt-get install -y brave-browser
}

install_bitwarden() {
    # This download currently provides the amd64 package.
    if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
        echo "The Bitwarden DEB installer is configured for amd64 only."
        return 1
    fi

    local deb_file="$TEMP_DIR/bitwarden.deb"

    # libsecret is used by Bitwarden for secure storage on Linux.
    sudo apt-get install -y libsecret-1-0

    echo "Downloading the latest Bitwarden DEB package..."

    curl --proto '=https' --tlsv1.2 -fL --retry 3 \
        "https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=deb" \
        -o "$deb_file"

    echo "Installing Bitwarden..."
    sudo apt-get install -y "$deb_file"
}

install_brave
install_bitwarden

echo
echo "DEB applications installed successfully."