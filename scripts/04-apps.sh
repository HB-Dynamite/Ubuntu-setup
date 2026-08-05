#!/usr/bin/env bash

set -Eeuo pipefail

# Ensure that Snap is installed.
sudo apt-get install -y snapd

# Install a Snap application only when it is not already installed.
install_snap() {
    local package="$1"
    local mode="${2:-}"

    if snap list "$package" >/dev/null 2>&1; then
        echo "$package is already installed."
        return
    fi

    echo "Installing $package..."

    if [[ "$mode" == "classic" ]]; then
        sudo snap install "$package" --classic
    else
        sudo snap install "$package"
    fi
}

# Install Brave from its official APT repository.
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

# VS Code requires classic confinement so it can access development files
# and tools outside its isolated Snap environment.
install_snap code classic

install_snap slack
install_snap spotify

install_brave

echo
echo "Desktop applications installed successfully."

# Show the installed versions.
snap list code slack spotify
