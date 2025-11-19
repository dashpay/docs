#!/usr/bin/env bash
set -euo pipefail

echo "Installing fish from distro package manager..."

if command -v apt-get >/dev/null 2>&1; then
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends fish
    rm -rf /var/lib/apt/lists/*
else
    echo "Unsupported base image: expected apt-get (Ubuntu/Debian)." >&2
    exit 1
fi
