#!/bin/bash
set -eu

NETWORK_ID=${1:-""}

echo "Downloading snapshot for network [$NETWORK_ID]"

URLS=$(jq -r ".\"$NETWORK_ID\" // empty | .[]" /snapshot/snapshots.json)
if [ -z "$URLS" ]; then
  echo "Unsupported Snapshot [$NETWORK_ID]"
  exit 1
fi

echo "$URLS" | xargs -n 1 -P 2 aria2c -x 4 -s 4 -d /data --retry-wait=10 --max-tries=3
echo "Download snapshot completed. Unpacking..."

for FILE in /data/*.tar.lz4; do
  echo "Extracting $FILE..."
  tar -I lz4 -xvf "$FILE" -C /
  rm "$FILE"
done
mv /geth /data

echo "Extract snapshot completed."