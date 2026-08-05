#!/usr/bin/env bash

set -Eeuo pipefail

# Install Miniforge inside the current user's home directory.
readonly INSTALL_DIR="$HOME/miniforge3"

# Do not reinstall Miniforge if Conda is already present there.
if [[ -x "$INSTALL_DIR/bin/conda" ]]; then
    echo "Conda is already installed."
    "$INSTALL_DIR/bin/conda" --version
    exit 0
fi

# Select the correct installer for the computer's processor architecture.
case "$(uname -m)" in
    x86_64)
        ARCH="x86_64"
        ;;
    aarch64 | arm64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)"
        exit 1
        ;;
esac

readonly INSTALLER_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${ARCH}.sh"

# Create a temporary file for the installer.
INSTALLER_FILE="$(mktemp)"

# Delete the installer when the script finishes, including after an error.
trap 'rm -f "$INSTALLER_FILE"' EXIT

echo "Downloading Miniforge..."
curl -fsSL "$INSTALLER_URL" -o "$INSTALLER_FILE"

echo "Installing Miniforge in: $INSTALL_DIR"

# -b installs without interactive questions.
# -p specifies the installation directory.
bash "$INSTALLER_FILE" -b -p "$INSTALL_DIR"

# Configure Conda so that it is available in new Bash terminals.
"$INSTALL_DIR/bin/conda" init bash

# Do not automatically activate the base environment when opening a terminal.
"$INSTALL_DIR/bin/conda" config --set auto_activate_base false

echo
echo "Conda installed successfully."
"$INSTALL_DIR/bin/conda" --version

echo
echo "Open a new terminal before using Conda."