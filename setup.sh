#!/usr/bin/env bash

# Stop the script when a command fails, an undefined variable is used,
# or a command inside a pipeline fails.
set -Eeuo pipefail

# Get the absolute directory in which setup.sh is located.
readonly SCRIPT_DIR="$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
    pwd
)"

# Run one installation script and show which script is currently active.
run_script() {
    local script="$1"

    echo
    echo "=================================================="
    echo "Running: $(basename "$script")"
    echo "=================================================="

    # Stop with a clear error if the script does not exist.
    if [[ ! -f "$script" ]]; then
        echo "Error: Script not found: $script"
        exit 1
    fi

    # Run the script with Bash.
    bash "$script"
}

# The setup should run as the normal user.
# Individual commands use sudo only when administrator rights are required.
if [[ $EUID -eq 0 ]]; then
    echo "Do not run this script as root."
    echo "Run: ./setup.sh"
    exit 1
fi

# Ask for the sudo password once before starting the installation.
sudo -v

# Run the individual setup steps in the intended order.
run_script "$SCRIPT_DIR/scripts/01-system-packages.sh"
run_script "$SCRIPT_DIR/scripts/02-development-tools.sh"
run_script "$SCRIPT_DIR/scripts/03-conda.sh"

echo
echo "=================================================="
echo "Ubuntu setup completed successfully."
echo "=================================================="
