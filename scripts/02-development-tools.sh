#!/usr/bin/env bash

# Stop the script if a command fails or an undefined variable is used.
set -Eeuo pipefail

# General development tools and basic Python tooling.
PACKAGES=(
    git
    git-lfs
    build-essential
    cmake
    pkg-config
    shellcheck
    python3-full
    python3-dev
    python3-pip
    pipx
)

echo "Installing development tools..."
sudo apt-get install -y "${PACKAGES[@]}"

# Configure Git Large File Storage for the current user.
git lfs install

# Make applications installed through pipx available in the PATH.
pipx ensurepath

echo
echo "Development tools installed successfully."
echo "Git: $(git --version)"
echo "Python: $(python3 --version)"