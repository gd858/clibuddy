#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# A script that transforms natural language instructions into Linux commands
# using the OpenAI GPT API. This version shows the command and prompts you
# before running it (interactive mode).
# -----------------------------------------------------------------------------

# -----------------------------
# Configuration & Constants
# -----------------------------
API_KEY_FILE="$HOME/.config/clibuddy/api_key"
DEFAULT_MODEL="gpt-4"
DEFAULT_TEMPERATURE="0"
PROGRAM_NAME=$(basename "$0")

# -----------------------------
# Functions
# -----------------------------
usage() {
  cat <<EOF
Usage: $PROGRAM_NAME [options] "<instruction>"

Options:
  -h, --help          Show this help message and exit
  -v, --verbose       Print debug messages
  -i, --interactive   Prompt to run the returned command after displaying it
  -m, --model MODEL   Specify the OpenAI model (default: $DEFAULT_MODEL)
  -t, --temp VALUE    Set temperature for the GPT model (default: $DEFAULT_TEMPERATURE)

Examples:
  $PROGRAM_NAME "List all files in the current directory"
  $PROGRAM_NAME -v -i "Show disk usage for home directory"

Description:
  This script sends your natural language instruction to an OpenAI model
  to get a single valid Linux command in response. By default, it only
  prints the resulting command. With '-i', you will be prompted to run it.
EOF
}

error() {
  echo "Error: $1" >&2
  exit 1
}

log_debug() {
  if [ "$VERBOSE" = true ]; then
    echo "Debug: $1"
  fi
}

check_dependencies() {
  for cmd in jq curl; do
    if ! command -v "$cmd" &> /dev/null; then
      error "'$cmd' command is required but not installed."
    fi
  done
}

# -----------------------------
# Argument Parsing
# -----------------------------
VERBOSE=false
INTERACTIVE=false
MODEL="$DEFAULT_MODEL"
TEMPERATURE="$DEFAULT_TEMPERATURE"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -i|--interactive)
      INTERACTIVE=true
      shift
      ;;
    -m|--model)
      MODEL="$2"
      shift 2
      ;;
    -t|--temp)
      TEMPERATURE="$2"
      shift 2
      ;;
    *)
      USER_INPUT="$1"
      shift
      break
      ;;
  esac
done

# If there's anything left after the first non-option argument,
# treat it as part of the instruction:
if [ $# -gt 0 ]; then
  USER_INPUT="$USER_INPUT $*"
fi

# -----------------------------
# Validation
# -----------------------------
if [ -z "$USER_INPUT" ]; then
  usage
  exit 1
fi

if [ ! -f "$API_KEY_FILE" ]; then
  error "API key file not found at $API_KEY_FILE."
fi

OPENAI_API_KEY=$(< "$API_KEY_FILE")

if [ -z "$OPENAI_API_KEY" ]; then
  error "No API key found in $API_KEY_FILE."
fi

check_dependencies

# -----------------------------
# Main
# -----------------------------
log_debug "User input: $USER_INPUT"
log_debug "Using model: $MODEL"
log_debug "Using temperature: $TEMPERATURE"

PROMPT="You are a terminal assistant specialized in converting natural language instructions into precise and valid Linux terminal commands. Always provide a single valid command in your response, without any additional text or explanations. Ensure the command is executable directly in a Linux terminal. If the input is unclear or ambiguous, attempt to provide the most likely command based on common usage.

Instruction: $USER_INPUT
Command:"

JSON_PAYLOAD=$(jq -n \
  --arg prompt "$PROMPT" \
  --arg model "$MODEL" \
  --arg temp "$TEMPERATURE" \
  '{
    model: $model,
    messages: [{role: "user", content: $prompt}],
    temperature: ($temp | tonumber)
  }'
)

log_debug "JSON payload: $JSON_PAYLOAD"

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD")

log_debug "API response: $RESPONSE"

COMMAND=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

log_debug "Extracted command: $COMMAND"

if [ "$COMMAND" == "null" ] || [ -z "$COMMAND" ]; then
  error "Failed to retrieve a valid command from OpenAI."
fi

# Show the command:
echo "$COMMAND"

# If in interactive mode, prompt the user to run it:
if [ "$INTERACTIVE" = true ]; then
  read -r -p "Would you like to run this command? [y/N]: " CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Running command..."
    eval "$COMMAND"
  else
    echo "Skipping execution."
  fi
fi

