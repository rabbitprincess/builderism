#!/bin/bash
set -eu

cd /app/op-scan && cp /data/.env.local .env.local
export $(grep -v '^#' .env.local | xargs)

pnpm build && pnpm start