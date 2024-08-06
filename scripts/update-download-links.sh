#!/bin/bash

# Script to update the download/install related version references when a new
# Dash Core version is released

# Define old and new version variables
OLD_VERSION="21.0.0"
NEW_VERSION="21.0.2"

# Use the variables in the find/sed commands
find . -iname "*.rst" -exec sed -i "s~/v${OLD_VERSION}/dashcore-${OLD_VERSION}-~/v${NEW_VERSION}/dashcore-${NEW_VERSION}-~g" {} +
find . -iname "*.rst" -exec sed -i "s~dashcore-${OLD_VERSION}-~dashcore-${NEW_VERSION}-~g" {} +
find . -iname "*.rst" -exec sed -i "s~dashcore-${OLD_VERSION}~dashcore-${NEW_VERSION}~g" {} +
