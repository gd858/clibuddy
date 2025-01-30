
#!/usr/bin/env bash

# Define paths
INSTALL_DIR="/usr/local/bin"
SHARE_DIR="/usr/share/clibuddy"
CONFIG_DIR="$HOME/.config/clibuddy"

# Define files
CLI_SCRIPT="$INSTALL_DIR/clibuddy"
INSTALL_SCRIPT="$INSTALL_DIR/clibuddy-installer"
ASSET_FILE="$SHARE_DIR/robot.txt"
API_KEY_FILE="$CONFIG_DIR/api_key"

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
  error "This script must be run as root. Try running: sudo ./uninstaller.sh"
fi

echo -e "${CYAN}🔧 Uninstalling CliBuddy...${RESET}"

# Remove files
if [[ -f "$CLI_SCRIPT" ]]; then
  rm -f "$CLI_SCRIPT" && success "Removed clibuddy CLI script."
else
  warning "clibuddy CLI script not found."
fi

if [[ -f "$INSTALL_SCRIPT" ]]; then
  rm -f "$INSTALL_SCRIPT" && success "Removed clibuddy installer script."
else
  warning "Installer script not found."
fi

if [[ -f "$ASSET_FILE" ]]; then
  rm -f "$ASSET_FILE" && success "Removed robot.txt."
else
  warning "robot.txt not found."
fi

# Remove directories if empty
if [[ -d "$SHARE_DIR" ]]; then
  rmdir --ignore-fail-on-non-empty "$SHARE_DIR" && success "Removed shared directory."
fi

if [[ -d "$CONFIG_DIR" ]]; then
  read -p "Do you want to remove your OpenAI API key? (y/N): " CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    rm -f "$API_KEY_FILE"
    rmdir --ignore-fail-on-non-empty "$CONFIG_DIR" && success "Removed config directory."
  else
    warning "Keeping API key in $API_KEY_FILE."
  fi
fi

echo -e "✅ ${GREEN}CliBuddy has been uninstalled.${RESET}"
