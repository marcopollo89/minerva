#!/bin/bash

# Master batch updater for Minerva Sales Reporting
# Expects a file called update_manifest.txt in the same directory
# Each line in the manifest: [source_file] [relative_target_path_from_sales_reporting]

TARGET_DIR=~/Desktop/project_minerva/sales_reporting
MANIFEST="update_manifest.txt"

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: update_manifest.txt not found in current directory."
  exit 1
fi

echo "This will apply the following patches:"
cat "$MANIFEST"
read -p "Continue? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  echo "Cancelled."
  exit 0
fi

while read line; do
  SRC_FILE=$(echo $line | cut -d' ' -f1)
  DEST_PATH=$(echo $line | cut -d' ' -f2)
  FULL_DEST="$TARGET_DIR/$DEST_PATH"

  echo "Patching: $SRC_FILE -> $FULL_DEST"
  cp "$SRC_FILE" "$FULL_DEST" && echo "✓ Success" || echo "✗ Failed"
done < "$MANIFEST"
