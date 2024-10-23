#!/bin/bash

# Script to update the download/install related version references when a new
# Dash Core version is released

# Command to get latest Dash Core tag name
NEW_VERSION=$(curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/dashpay/dash/releases/latest | \
  jq -r '.tag_name' | sed 's/^v//')

if [[ $? -ne 0 || -z "$NEW_VERSION" ]]; then
  echo "Error: Unexpected response when retrieving the current Dash Core version. Received: $NEW_VERSION"
else
  NEW_VERSION=0.0.1 # test
  # Print the extracted values (for verification)
  echo "Extracted Version: $NEW_VERSION"
  git checkout -b v$NEW_VERSION-links

  # Use the variables in the find/sed commands
  find . -iname "*.rst" ! -name "compiling.rst" -exec sed -i "s~/v[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}/dashcore-[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}-~/v${NEW_VERSION}/dashcore-${NEW_VERSION}-~g" {} +
  find . -iname "*.rst" ! -name "compiling.rst" -exec sed -i "s~dashcore-[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}-~dashcore-${NEW_VERSION}-~g" {} +
  find . -iname "*.rst" ! -name "compiling.rst" -exec sed -i "s~dashcore-[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}~dashcore-${NEW_VERSION}~g" {} +

  echo "Dash Core version updated to ${NEW_VERSION} in documentation"
fi
