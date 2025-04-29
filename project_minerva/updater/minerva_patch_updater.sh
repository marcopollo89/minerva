#!/bin/bash

# Usage: ./minerva_patch_updater.sh [source_file] [relative_target_path_from_sales_reporting]
# Example: ./minerva_patch_updater.sh sales_helpers.php helpers/sales_helpers.php

SRC_FILE=$1
DEST_PATH=$2
TARGET_DIR=~/Desktop/project_minerva/sales_reporting

if [ -z "$SRC_FILE" ] || [ -z "$DEST_PATH" ]; then
  echo "Usage: ./minerva_patch_updater.sh [source_file] [relative_target_path_from_sales_reporting]"
  exit 1
fi

FULL_DEST="$TARGET_DIR/$DEST_PATH"

echo "About to overwrite:"
echo "$FULL_DEST"
read -p "Are you sure? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  echo "Cancelled."
  exit 0
fi

cp "$SRC_FILE" "$FULL_DEST" && echo "Patch applied: $SRC_FILE -> $FULL_DEST" || echo "Failed to apply patch."
