#!/bin/bash

API_KEY_FILE="$HOME/.openai_api_key"

if [ ! -f "$API_KEY_FILE" ]; then
  echo "Error: API key file not found at $API_KEY_FILE."
  exit 1
fi

OPENAI_API_KEY=$(cat "$API_KEY_FILE")

if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY environment variable is not set."
  exit 1
fi

if [ $# -lt 1 ]; then
  echo "Usage: $0 [-v] \"<instruction>\""
  exit 1
fi

# Check for verbose flag
VERBOSE=false
if [ "$1" == "-v" ]; then
  VERBOSE=true
  shift
fi

USER_INPUT=$1

log() {
  if [ "$VERBOSE" == true ]; then
    echo "$1"
  fi
}

log "Debug: User input received: $USER_INPUT"

PROMPT="You are a terminal assistant specialized in converting natural language instructions into precise and valid Linux terminal commands. Always provide a single valid command in your response, without any additional text or explanations. Ensure the command is executable directly in a Linux terminal. If the input is unclear or ambiguous, attempt to provide the most likely command based on common usage.

Instruction: $USER_INPUT
Command:"

# Properly escape JSON payload
JSON_PAYLOAD=$(jq -n --arg prompt "$PROMPT" '{
  model: "gpt-4",
  messages: [{role: "user", content: $prompt}],
  temperature: 0
}')

log "Debug: JSON payload: $JSON_PAYLOAD"

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD")

log "Debug: API response: $RESPONSE"

COMMAND=$(echo "$RESPONSE" | jq -r '.choices[0].message.content' 2>/dev/null)

log "Debug: Extracted command: $COMMAND"

if [ "$COMMAND" == "null" ] || [ -z "$COMMAND" ]; then
  echo "Error: Failed to retrieve a valid command."
else
  echo "$COMMAND"
fi
