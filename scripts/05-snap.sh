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

# VS Code needs classic confinement for access to development tools and files.
install_snap code classic

# Regular Snap applications.
install_snap slack
install_snap spotify

echo
echo "Snap applications installed successfully."

echo
echo "Installed Snap applications:"
snap list code slack spotify