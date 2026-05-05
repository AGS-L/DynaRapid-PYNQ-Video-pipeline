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
RESET='\033[0m'

# Set default value if none is provided
FILTER_NAME="${1:-""}"

# Make sure the current working directory is where the script is located
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"

ROOT_DIR="$SCRIPT_DIR/../.."

# Folder where dynamatic runs
C_CODE_FOLDER="$ROOT_DIR/c_code"
C_CODE_REPORTS="$C_CODE_FOLDER/reports"

# Folder where tools can be found
TOOLS_DIR="$ROOT_DIR/tools"

# Folder where DynaRapid runs
DYNARAPID_INSTALL="$TOOLS_DIR/DynaRapid"

# Folder where .dot files are found
DOT_FILE_FOLDER="$SCRIPT_DIR/filters/$FILTER_NAME"

# Check if the folder exists
if [[ ! -d "$DOT_FILE_FOLDER/" ]]; then
    echo -e "${RED}[ERROR] Folder '$DOT_FILE_FOLDER/' not found${RESET}"
    exit 1
fi

cd "$DYNARAPID_INSTALL"

# Clean-up previous DynaRapid run, to check for successful DynaRapid run
rm -rf "$C_CODE_FOLDER/designs/filter"

# Run DynaRapid
./gradlew :GenerateDesign --args="-f $DOT_FILE_FOLDER/filter.dot -placer greedy -part xczu3eg"

# Check if DynaRapid was successful
# Currently DynaRapid doesn't return an error code, so only way to check if successful is if output was created; check when moving
mv "$DYNARAPID_INSTALL/designs/filter/filter_routed.dcp" "$DOT_FILE_FOLDER/filter_routed.dcp"

cd "$SCRIPT_DIR"

# Generate bitstream
vivado -mode batch -source generate_bitstream.tcl -tclargs "$FILTER_NAME"

echo -e "$GREEN[SUCCESS] Created bitstream and device tree blob for filter '$FILTER_NAME'$RESET"
)
