
#!/usr/bin/env bash

# -----------------------------
# 1. Run Setup Script First
# -----------------------------
SETUP_SCRIPT="./setup.sh"

if [[ -f "$SETUP_SCRIPT" ]]; then
  echo -e "${CYAN}🔧 Running setup...${RESET}"
  sudo bash "$SETUP_SCRIPT" || { echo -e "${RED}❌ Setup failed. Exiting.${RESET}"; exit 1; }
else
  echo -e "${RED}❌ Setup script not found!${RESET}"
  exit 1
fi

# -----------------------------
# 2. Define Colors
# -----------------------------
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
UNDERLINE=$(tput smul)
RESET=$(tput sgr0)

# -----------------------------
# 3. API Key Storage Path
# -----------------------------
CONFIG_DIR="$HOME/.config/clibuddy"
API_KEY_FILE="$CONFIG_DIR/api_key"

# -----------------------------
# 4. Typewriter-Effect Function with Colors
# -----------------------------
typewriter() {
  local text="$1"
  local delay="${2:-0.04}"  
  local color="${3:-$WHITE}"

  echo -ne "$color"
  for (( i=0; i<${#text}; i++ )); do
    echo -n "${text:$i:1}"
    sleep "$delay"
  done
  echo -e "$RESET"
}

# -----------------------------
# 5. Animated Progress Dots
# -----------------------------
progress() {
  local duration="${1:-3}"
  local delay=0.2
  local spin='|/-\'

  for ((i = 0; i < duration * 5; i++)); do
    echo -ne "${YELLOW}${spin:i%4:1}${RESET} Installing...\r"
    sleep "$delay"
  done
  echo -e "✅ ${GREEN}Done!${RESET}"
}

# -----------------------------
# 6. Main Banner (Colorized)
# -----------------------------
banner() {
  echo -e "${BOLD}${CYAN}"
  cat /usr/share/clibuddy/robot.txt 2>/dev/null || echo "⚠️ robot.txt not found!"
  echo -e "${RESET}"
}

# -----------------------------
# 7. Tutorial Message (Formatted)
# -----------------------------
tutorial_message() {
  cat <<EOF
${BOLD}${YELLOW}HELLO! I am ${CYAN}CliBuddy${YELLOW} :) here to guide you through your Linux CLI experience.${RESET}

${GREEN}1.${RESET} Run the script with ${BOLD}-h${RESET} or ${BOLD}--help${RESET} to see options.
${GREEN}2.${RESET} Use ${BOLD}-i${RESET} for interactive mode to confirm commands before they run.
${GREEN}3.${RESET} Specify ${BOLD}-m <model>${RESET} to choose the OpenAI model.

${MAGENTA}Examples:${RESET}
${CYAN}clibuddy -i "create a directory"${RESET}
${CYAN}clibuddy -i "run updates on Fedora system"${RESET}

EOF
}

# -----------------------------
# 8. Securely Store OpenAI API Key
# -----------------------------
store_api_key() {
  echo -e "${BOLD}${CYAN}Please enter your OpenAI API key:${RESET}"
  
  # Read input while hiding it
  read -s -r api_key

  # Ensure the input is not empty
  if [[ -z "$api_key" ]]; then
    echo -e "${RED}API key cannot be empty. Please try again.${RESET}"
    store_api_key
    return
  fi

  # Ensure config directory exists
  mkdir -p "$CONFIG_DIR"

  # Save the key securely
  echo "$api_key" > "$API_KEY_FILE"
  chmod 600 "$API_KEY_FILE"

  echo -e "✅ ${GREEN}Your OpenAI API key has been securely saved.${RESET}"
}

# -----------------------------
# 9. Putting It All Together
# -----------------------------
clear
banner

# Animate the tutorial instructions line by line
while IFS= read -r line; do
  typewriter "$line" 0.03 "$WHITE"
done < <(tutorial_message)

if [[ ! -f "$API_KEY_FILE" ]]; then
  store_api_key
else
  echo -e "🔑 ${GREEN}OpenAI API key already exists at:${RESET} ${CYAN}$API_KEY_FILE${RESET}"
fi

# Show a progress indicator
progress 3

# Optionally, wait or show a final line
typewriter "${GREEN}Thank you for installing! Press ENTER to continue...${RESET}" 0.03
read -r _

