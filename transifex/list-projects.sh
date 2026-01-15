#!/usr/bin/env bash

RTD_BASE_URL=${RTD_BASE_URL:-https://app.readthedocs.org}

# Function to list all project slugs (with pagination support)
list_slugs() {
    echo "Fetching all project slugs from ReadTheDocs..."
    echo ""

    local url="${RTD_BASE_URL}/api/v3/projects/"
    local page=1

    while [ -n "$url" ]; do
        response=$(curl -s -w "\n%{http_code}" \
            -H "Authorization: Token ${RTD_TOKEN}" \
            "$url")

        http_code=$(echo "$response" | tail -n1)
        body=$(echo "$response" | sed '$d')

        if [ "$http_code" = "200" ]; then
            # Display results (with jq if available, otherwise grep)
            echo "$body" | jq -r '.results[] | "  \(.slug) - \(.name)"' 2>/dev/null || \
                echo "$body" | grep -o '"slug":"[^"]*"' | cut -d'"' -f4

            # Get next page URL
            url=$(echo "$body" | jq -r '.next // empty' 2>/dev/null)

            if [ -n "$url" ]; then
                echo "  (loading page $((++page))...)"
            fi
        else
            echo "✗ Failed to fetch projects (HTTP $http_code)"
            echo "  Response: $body"
            exit 1
        fi
    done
    echo ""
}

# List all available project slugs
list_slugs
