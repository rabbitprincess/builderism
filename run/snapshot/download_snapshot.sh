#!/bin/bash
set -eu

NETWORK_ID=${1:-""}

if [ -d "/data/chaindata" ]; then
  echo "Chaindata folder already exists. Skipping snapshot download and extraction."
else
  echo "[1/2] Downloading snapshot for network: [$NETWORK_ID]"

  URLS=$(jq -r ".\"$NETWORK_ID\" // empty | .[]" /snapshot/snapshots.json)
  if [ -z "$URLS" ]; then
    echo "Error: Unsupported snapshot [$NETWORK_ID]"
    exit 1
  fi

  echo "$URLS" | xargs -n 1 -P 4 wget --retry-connrefused --waitretry=10 \
    --timeout=60 --tries=5 -P /data -c

  echo "Download snapshot completed. Unpacking..."

  for FILE in /data/*.tar.lz4; do
    echo "Extracting: $FILE"
    tar -I lz4 -xvf "$FILE" -C /data
    rm -f "$FILE"
  done

  mv /data/geth/* /data/
  rm -rf /data/geth

  echo "Snapshot initialization completed!"
fi