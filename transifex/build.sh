#!/bin/bash

# Triggers a build of readthedocs sub-projects for each supported language
# Uses ReadTheDocs API v3: https://docs.readthedocs.com/platform/stable/api/v3.html#build-triggering
#
# Required environment variables (export via .env file):
#   RTD_TOKEN - Your ReadTheDocs API token from https://app.readthedocs.org/accounts/tokens/
#   RTD_BASE_URL - Base URL (default: https://app.readthedocs.org)
#
# Optional: Set specific project slugs, otherwise defaults are used

RTD_BASE_URL=${RTD_BASE_URL:-https://app.readthedocs.org}
VERSION=${VERSION:-stable}

# Function to trigger a build for a project
trigger_build() {
    local project_slug=$1
    local project_name=$2

    echo "Triggering build for $project_name (${project_slug})..."

    response=$(curl -s -w "\n%{http_code}" -X POST \
        -H "Authorization: Token ${RTD_TOKEN}" \
        "${RTD_BASE_URL}/api/v3/projects/${project_slug}/versions/${VERSION}/builds/")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" = "202" ]; then
        echo "✓ Build triggered successfully for $project_name"
    else
        echo "✗ Failed to trigger build for $project_name (HTTP $http_code)"
        echo "  Response: $body"
    fi
}

# Check if RTD_TOKEN is set
if [ -z "$RTD_TOKEN" ]; then
    echo "Error: RTD_TOKEN environment variable is not set"
    echo "Get your token from: https://app.readthedocs.org/accounts/tokens/"
    exit 1
fi

# Trigger builds for each language project
trigger_build "${ARABIC_PROJECT:-dash-arabic}" "Arabic"
trigger_build "${FILIPINO_PROJECT:-dash-filipino}" "Filipino"
trigger_build "${FRENCH_PROJECT:-dash-french}" "French"
trigger_build "${GERMAN_PROJECT:-dash-german}" "German"
trigger_build "${GREEK_PROJECT:-dash-greek}" "Greek"
trigger_build "${ITALIAN_PROJECT:-dash-italian}" "Italian"
trigger_build "${JAPANESE_PROJECT:-dash-japanese}" "Japanese"
trigger_build "${KOREAN_PROJECT:-dash-korean}" "Korean"
trigger_build "${PORTUGUESE_PROJECT:-dash-portuguese}" "Portuguese"
trigger_build "${RUSSIAN_PROJECT:-dash-russian}" "Russian"
trigger_build "${SIMPLIFIED_CHINESE_PROJECT:-dash-simplified-chinese}" "Simplified Chinese"
trigger_build "${SPANISH_PROJECT:-dash-spanish}" "Spanish"
trigger_build "${TRADITIONAL_CHINESE_PROJECT:-dash-traditional-chinese}" "Traditional Chinese"
trigger_build "${VIETNAMESE_PROJECT:-dash-vietnamese}" "Vietnamese"
