#!/usr/bin/env bash
# Starts the Azurite blob emulator (local Azure Storage emulator) on 127.0.0.1:10000
# and installs @azure/storage-blob for post-upload verification.
set -euo pipefail
PREFIX=/tmp/azt
mkdir -p "$PREFIX" /tmp/azurite-data
if [ ! -x "$PREFIX/node_modules/.bin/azurite-blob" ]; then
  npm install --silent --no-audit --no-fund --prefix "$PREFIX" azurite@3 @azure/storage-blob@12 >/tmp/azt-npm.log 2>&1 || {
    cat /tmp/azt-npm.log; exit 1; }
fi
nohup setsid "$PREFIX/node_modules/.bin/azurite-blob" \
  --blobHost 127.0.0.1 --blobPort 10000 \
  --location /tmp/azurite-data --skipApiVersionCheck --loose \
  >/tmp/azurite.log 2>&1 < /dev/null &
for i in $(seq 1 60); do
  if curl -s -o /dev/null "http://127.0.0.1:10000/devstoreaccount1?comp=list"; then
    echo "Azurite is up"
    exit 0
  fi
  sleep 1
done
echo "Azurite failed to start"
cat /tmp/azurite.log || true
exit 1
