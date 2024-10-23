#!/bin/bash

NETWORK_ID=${1:-""}

echo "Downloading snapshot for network [$NETWORK_ID]"

URLS=$(jq -r ".\"$NETWORK_ID\" // empty | .[]" /snapshot/snapshots.json)
if [ -z "$URLS" ]; then
  echo "Unsupported Snapshot [$NETWORK_ID]"
  exit 1
fi

echo "$URLS" | xargs -n 1 -P 8 aria2c -x 16 -s 16 -d /data
echo "Download snapshot completed. Unpacking..."

for FILE in /data/*.tar.lz4; do
  echo "Extracting $FILE..."
  tar --lz4 -xvf "$FILE" -C /data
  rm "$FILE"
done
echo "Extract snapshot completed."