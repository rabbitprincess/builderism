#!/bin/bash
set -eu

cd /app/op-scan && cp /config/scan.env .env.local
export $(grep -v '^#' .env.local | xargs)

pnpm build && pnpm start