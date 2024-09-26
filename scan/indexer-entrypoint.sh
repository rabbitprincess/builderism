#!/bin/bash
set -eu

cd /app/op-scan && cp /config/scan.env .env.local
export $(grep -v '^#' .env.local | xargs)

pnpm prisma:db:push

pnpm op-indexer