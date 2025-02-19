#!/bin/bash

# Checks build status for most recent builds of readthedocs sub-projects for each supported language
# Token should be exported via a .env file

# Define the main project slug
main_project_slug="dash-docs"

# Fetch the main project's details including translations
response=$(curl -s -H "Authorization: Token $RTD_TOKEN" "https://readthedocs.org/api/v3/projects/$main_project_slug/translations/?limit=20")

# Loop through each translation project
echo $response | jq -c '.results[]' | while read -r translation; do
    slug=$(echo $translation | jq -r '.slug')
    language_name=$(echo $translation | jq -r '.language.name')

    echo -e "\e[1m$language_name ($slug) build status...\e[0m"
    
    # Make the API call
    response=$(curl -s -H "Authorization: Token $RTD_TOKEN" "https://readthedocs.org/api/v3/projects/$slug/builds/?limit=2")

    # Extract and display build information
    echo $response | jq -r '.results[] | "  Version: \(.version), Status: \(.state.name), Success: \(.success), Created: \(.created), \(.urls.build)"' | while read -r line; do
        if [[ "$line" == *"Status: Triggered"* ]]; then
            echo -e "  \e[1;31m$line\e[0m"  # Highlight in red
        elif [[ "$line" == *"Status: Finished, Success: true"* ]]; then
            echo -e "  \e[1;34m$line\e[0m"  # Highlight in blue
        elif [[ "$line" == *"Status: Finished, Success: false"* ]]; then
            echo -e "  \e[1;93m$line\e[0m"  # Highlight in yellow
        elif [[ "$line" == *"Status: Building"* || "$line" == *"Status: Installing"* ]]; then
            echo -e "  \e[1;32m$line\e[0m"  # Highlight in green            
        else
          echo " $line"
        fi
    done
done
