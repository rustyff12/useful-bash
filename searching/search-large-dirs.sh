#!/bin/bash

# Set the root directory (use current dir if none provided)
ROOT_DIR="${1:-.}"

# Directories to detect and skip descending into
# STOP_DIRS=("node_modules" ".venv" "venv" "env" "__pycache__")
STOP_DIRS=("node_modules" ".venv" "venv" "env")

# Recursively scan directories
scan_dir() {
    local dir="$1"

    # Internal Field Separator for filenames with spaces
    IFS=$'\n'
    for entry in "$dir"/*; do
        [ -e "$entry" ] || continue  # Skip if entry doesn't exist
        local basename
        basename="$(basename "$entry")"

        for stop in "${STOP_DIRS[@]}"; do
            if [[ "$basename" == "$stop" ]]; then
                echo "Found: $entry"
                return  # Stop descending this path
            fi
        done

        # Recurse into directories
        if [[ -d "$entry" ]]; then
            scan_dir "$entry"
        fi
    done
    unset IFS
}

echo "Scanning directory: $ROOT_DIR"
scan_dir "$ROOT_DIR"
