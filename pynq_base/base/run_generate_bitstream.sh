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
OUTPUT_FOLDER="$SCRIPT_DIR/filters/$FILTER_NAME"

# Check if the folder exists
if [[ ! -d "$OUTPUT_FOLDER/" ]]; then
    echo -e "${RED}[ERROR] Folder '$OUTPUT_FOLDER/' not found${RESET}"
    exit 1
fi

# Check if file present
if [[ ! -f "$OUTPUT_FOLDER/filter.dot" ]]; then
    echo -e "${RED}[ERROR] Failed to find DFG '$OUTPUT_FOLDER/filter.dot'${RESET}"
    exit 1
fi

cd "$DYNARAPID_INSTALL"

# Clean-up previous DynaRapid run, to check for successful DynaRapid run
rm -rf "$C_CODE_FOLDER/designs/filter"

# Run DynaRapid
./gradlew :GenerateDesign --args="-f $OUTPUT_FOLDER/filter.dot -placer greedy -part xczu3eg -noClock -region 0 -targetPeriod 3 -streaming"

# Check if DynaRapid was successful
# Currently DynaRapid doesn't return an error code, so only way to check if successful is if output was created; check when moving
mv "$DYNARAPID_INSTALL/designs/filter/filter_routed.dcp" "$OUTPUT_FOLDER/filter_routed1.dcp"

# Save modified dot file, if it has been modified
if ! cmp -s "$DYNARAPID_INSTALL/designs/filter/filter.dot" "$OUTPUT_FOLDER/filter.dot"; then
    mv "$DYNARAPID_INSTALL/designs/filter/filter.dot" "$OUTPUT_FOLDER/filter_modified.dot"
fi

rm -rf "$C_CODE_FOLDER/designs/filter"

./gradlew :GenerateDesign --args="-f $OUTPUT_FOLDER/filter.dot -placer greedy -part xczu3eg -noClock -region 1 -targetPeriod 3 -streaming"

mv "$DYNARAPID_INSTALL/designs/filter/filter_routed.dcp" "$OUTPUT_FOLDER/filter_routed2.dcp"

cd "$SCRIPT_DIR"

# Generate bitstream
vivado -mode batch -source generate_bitstream.tcl -tclargs "$FILTER_NAME"

echo -e "$GREEN[SUCCESS] Created bitstream for filter '$FILTER_NAME'$RESET"
)
