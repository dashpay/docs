#!/bin/bash

# Script to update the download/install related version references when a new
# Dash Evo Tool version is released

# Command to get latest Dash Evo Tool tag name
NEW_VERSION=$(curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/dashpay/dash-evo-tool/releases/latest | \
  jq -r '.tag_name' | sed 's/^v//')

if [[ $? -ne 0 || -z "$NEW_VERSION" ]]; then
  echo "Error: Unexpected response when retrieving the current version. Received: $NEW_VERSION"
else
  # Print the extracted values (for verification)
  echo "Extracted Version: $NEW_VERSION"
  # git checkout -b v$NEW_VERSION-links # Uncomment to use locally

  # Use the variables in the find/sed commands
  find . -iname "*.rst" -exec sed -i "s~https://github\.com/dashpay/dash-evo-tool/releases/download/v[0-9]\+\.[0-9]\+\.[0-9]\+~https://github.com/dashpay/dash-evo-tool/releases/download/v${NEW_VERSION}~g" {} +

  echo "Dash Evo Tool version updated to ${NEW_VERSION} in documentation"
fi
