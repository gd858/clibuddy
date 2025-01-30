
#!/usr/bin/env bash

# Define paths
INSTALL_DIR="/usr/local/bin"
SHARE_DIR="/usr/share/clibuddy"
CONFIG_DIR="$HOME/.config/clibuddy"

# Define files
CLI_SCRIPT="clibuddy.sh"
INSTALL_SCRIPT="installer.sh"
ASSET_FILE="robot.txt"

# Colors for messages
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

# Function to print success message
success() {
  echo -e "✅ ${GREEN}$1${RESET}"
}

# Function to print error message
error() {
  echo -e "❌ ${RED}$1${RESET}"
  exit 1
}

# Function to print warning message
warning() {
  echo -e "⚠️  ${YELLOW}$1${RESET}"
}

# Ensure script is run with sudo
if [[ $EUID -ne 0 ]]; then
  error "This script must be run as root. Try running: sudo ./setup.sh"
fi

echo -e "${CYAN}🔧 Setting up CliBuddy...${RESET}"

# Create directories
mkdir -p "$INSTALL_DIR" || error "Failed to create $INSTALL_DIR"
mkdir -p "$SHARE_DIR" || error "Failed to create $SHARE_DIR"
mkdir -p "$CONFIG_DIR" || error "Failed to create $CONFIG_DIR"

success "Directories created successfully."

# Move files
install -m 755 "$CLI_SCRIPT" "$INSTALL_DIR/clibuddy" || error "Failed to install clibuddy.sh"
install -m 755 "$INSTALL_SCRIPT" "$INSTALL_DIR/clibuddy-installer" || error "Failed to install installer.sh"
install -m 644 "$ASSET_FILE" "$SHARE_DIR/robot.txt" || error "Failed to install robot.txt"

success "Files moved successfully."

# Check if CLI tool is accessible
if command -v clibuddy &>/dev/null; then
  success "CliBuddy installed successfully! 🎉"
  echo -e "Run ${CYAN}clibuddy -h${RESET} to get started."
else
  warning "CliBuddy installation completed, but you may need to restart your terminal for it to work."
fi
