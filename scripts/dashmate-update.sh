#!/bin/bash
# Update the dashmate download links and apt install commands with the latest dashmate version

# Command to get latest dashmate amd64 download URL
LATEST_URL=$(curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/dashpay/platform/releases/latest | \
  jq -r '.assets[] | select(.name | test("^dashmate.*amd64\\.deb$")) | .browser_download_url')

if [[ $? -ne 0 || -z "$LATEST_URL" ]]; then
  echo "Error: Unexpected response when retrieving the dashmate download URL. Received: $LATEST_URL"
else
  # Extract the version number from the URL
  NEW_VERSION=$(echo "$LATEST_URL" | grep -oP 'v[0-9]+\.[0-9]+\.[0-9]+')
  # Extract the filename from the URL
  NEW_FILE_NAME=$(basename "$LATEST_URL")

  # Check if either the version number or filename extraction failed
  if [[ -z "$NEW_VERSION" || -z "$NEW_FILE_NAME" ]]; then
    echo "Error: Failed to extract the version number or filename from the URL."
  else

  # Print the extracted values (for verification)
  echo "Extracted Version: $NEW_VERSION"
  echo "Extracted Filename: $NEW_FILE_NAME"

    # Find and replace the URL and filename references in .rst files
    find . -iname "*.rst" -exec sed -i "s~https://github.com/dashpay/platform/releases/download/v[0-9]\+\.[0-9]\+\.[0-9]\+/dashmate_[0-9]\+\.[0-9]\+\.[0-9]\+\.[a-f0-9]\+-[0-9]\+_amd64\.deb~https://github.com/dashpay/platform/releases/download/${NEW_VERSION}/${NEW_FILE_NAME}~g" {} +
    find . -iname "*.rst" -exec sed -i "s~dashmate_[0-9]\+\.[0-9]\+\.[0-9]\+\.[a-f0-9]\+-[0-9]\+_amd64\.deb~${NEW_FILE_NAME}~g" {} +
    echo "Dashmate version updated to ${NEW_VERSION} in documentation"
  fi
fi
