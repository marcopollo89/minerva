#!/bin/bash

# Minerva Batch Updater (Final Version)
# Expects update_manifest.txt to be in the same folder.
# Applies updates to ~/Desktop/project_minerva/sales_reporting/
# Backs up existing files to ~/Desktop/project_minerva/updater/backups/

TARGET_DIR=~/Desktop/project_minerva/sales_reporting
BACKUP_DIR=~/Desktop/project_minerva/updater/backups
MANIFEST="update_manifest.txt"

mkdir -p "$BACKUP_DIR"

if [ ! -f "$MANIFEST" ]; then
  echo "ERROR: update_manifest.txt not found."
  exit 1
fi

echo "Planned updates:"
cat "$MANIFEST"
echo ""
read -p "Proceed with these updates? (y/n): " confirm

if [[ "$confirm" != "y" ]]; then
  echo "Cancelled."
  exit 0
fi

while read -r line; do
  SRC_FILE=$(echo $line | cut -d' ' -f1)
  DEST_PATH=$(echo $line | cut -d' ' -f2)
  FULL_DEST="$TARGET_DIR/$DEST_PATH"

  if [ ! -f "$SRC_FILE" ]; then
    echo "✗ ERROR: Source file '$SRC_FILE' not found in updater directory. Skipping."
    continue
  fi

  if [ -f "$FULL_DEST" ]; then
    # Backup existing destination file
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_FILE="$BACKUP_DIR/${TIMESTAMP}_$(basename $DEST_PATH)"
    cp "$FULL_DEST" "$BACKUP_FILE"
    echo "→ Backed up old version to $BACKUP_FILE"
  fi

  # Copy patch file to destination
  cp "$SRC_FILE" "$FULL_DEST" && echo "✓ Updated: $DEST_PATH" || echo "✗ FAILED to update: $DEST_PATH"

done < "$MANIFEST"

echo ""
echo "Batch update process complete."
