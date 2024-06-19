#!/bin/bash

show_help() {
  echo "
Usage: $(basename "$0") [-f FOLDER_NUMBER] [-a] [-v] [-e]

Options:
  -f FOLDER_NUMBER  Specify a single folder to run from a collection:
                    1. Query
                    2. Dataset
                    3. Database
                    4. Util
                    5. Troubleshooting
                    6. HOS
                    7. Knowledge Base File
  -a                Run all options [1-7]
  -v                Enable verbose reporting
  -e                Enable emojitrain reporting
  -h, --help        Show this help message and exit
"
}

BASE_DIR="$(dirname "$(pwd)")"
CONFIG_PATH="$BASE_DIR/config"
FOLDER=""
ALL=false
VERBOSE_FLAG=false
EMOJITRAIN_FLAG=false

# Flag to check if any valid option is provided
VALID_OPTION_PROVIDED=false

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -f)
      VALID_OPTION_PROVIDED=true
      if [[ -n $2 && $2 =~ ^[1-7]$ ]]; then
        case $2 in
          1) FOLDER="--folder Query" ;;
          2) FOLDER="--folder Dataset" ;;
          3) FOLDER="--folder Database" ;;
          4) FOLDER="--folder Util" ;;
          5) FOLDER="--folder Troubleshooting" ;;
          6) FOLDER="--folder HOS" ;;
          7) FOLDER="--folder Knowledge Base File" ;;
        esac
        shift 2
      else
        echo "Error: Invalid folder number."
        show_help
        exit 1
      fi
      ;;
    -a)
      VALID_OPTION_PROVIDED=true
      ALL=true
      shift
      ;;
    -v)
      VERBOSE_FLAG=true
      shift
      ;;
    -e)
      EMOJITRAIN_FLAG=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Error: Unknown option $1"
      show_help
      exit 1
      ;;
  esac
done

if ! $VALID_OPTION_PROVIDED; then
  show_help
  exit 1
fi

if $ALL; then
  FOLDER=""
fi

NEW_MAN_OPTS=(
  "$CONFIG_PATH/tsg-olap-function-test-collection.json"
  -n 1
  -e "$CONFIG_PATH/environment.json"
  -g "$CONFIG_PATH/globals.json"
  --delay-request 200
  --timeout-script 10000
  --timeout-request 300000
  --timeout 3600000
  --insecure
)

# Add verbose reporting  option if enabled
if $VERBOSE_FLAG; then
  NEW_MAN_OPTS+=(--verbose)
fi

# Add folder option if set
if [[ -n $FOLDER ]]; then
  NEW_MAN_OPTS+=($FOLDER)
fi

# Add emojitrain reporting option if enabled
if $EMOJITRAIN_FLAG; then
  NEW_MAN_OPTS+=(-r emojitrain)
fi

# Run the newman command
newman run "${NEW_MAN_OPTS[@]}"

