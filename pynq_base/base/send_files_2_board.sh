#!/bin/bash

#######################################################################################################################
# Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
# Engineering and Architecture Department
# AGSL - Adaptive Heterogeneous Systems Lab
# Created by the AGSL Team (andrea.guerrieri@hevs.ch)
# All rights reserved.
# See LICENSE file for full license information.
#######################################################################################################################

# Start a subshell
(
# Exit immediately on error
set -Eeuo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# Set default value if none is provided
FILTER_NAME="${1:-""}"

# Make sure the current working directory is where the script is located
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

FOLDER_NAME="$SCRIPT_DIR/filters/$FILTER_NAME"

# Check if the folder exists
if [[ ! -d "$FOLDER_NAME/" ]]; then
    echo -e "${RED}[ERROR] Folder '$FOLDER_NAME/' not found${RESET}"
    exit 1
fi

# Create temp folder, as to avoid sending dcp
TEMP_FOLDER="$SCRIPT_DIR/filters/tmp/${FILTER_NAME}"

mkdir -p "$TEMP_FOLDER"

# Check if all files exist
for file in "${FILES[@]}"; do
    if [[ ! -f "$FOLDER_NAME/$file" ]]; then
        echo -e "${RED}[ERROR] Source file '$FOLDER_NAME/$file' not found${RESET}"
        rm -rf "$TEMP_FOLDER"
        exit 1
    else
        copy "$FOLDER_NAME/$file" "$TEMP_FOLDER/$file"
    fi
done

# Pynq remote path
REMOTE_PATH="xilinx@192.168.3.1:/home/xilinx"

# Send files to board
if ! scp -r "$FOLDER_NAME" "${REMOTE_PATH}/pynq/overlays"; then
    echo -e "${RED}[ERROR] Failed to send files to the board${RESET}"
    rm -rf "$TEMP_FOLDER"
    exit 1
fi

rm -rf "$TEMP_FOLDER"

# Check if the notebooks should be sent to the board
if [ "${2:-}" = "true" ]; then
    echo -e "${YELLOW}[WARNING] If notebooks of identical names exist on the AUP-ZU3, they will be overwritten.${RESET}"
    read -p "Are you sure you want to send all jupyter notebooks to the AUP-ZU3 board? <yes/no>: " USER_INPUT

    # Send notebooks to board
    if [ "$USER_INPUT" = "yes" ]; then
        if ! scp -r "$SCRIPT_DIR/notebook_examples" "${REMOTE_PATH}/jupyter_notebooks"; then
            echo -e "${RED}[ERROR] Failed to send notebooks to the board${RESET}"
            exit 1
        fi

        echo -e "${GREEN}[SUCCESS] Sent notebooks to the board${RESET}"
    fi
fi

echo -e "${GREEN}[SUCCESS] Folder '$FOLDER_NAME' created, files copied, and sent to the board${RESET}"
)
