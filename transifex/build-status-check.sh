# Checks build status for most recent builds of readthedocs sub-projects for each supported language
# Token should be exported via a .env file

# Define project slugs and their respective tokens
declare -A projects
projects[arabic]=dash-arabic
projects[english]=dash-docs
projects[filipino]=dash-filipino
projects[french]=dash-french
projects[german]=dash-german
projects[greek]=dash-greek
projects[italian]=dash-italian
projects[japanese]=dash-japanese
projects[korean]=dash-korean
projects[portuguese]=dash-portuguese
projects[russian]=dash-russian
projects[simplified-chinese]=dash-simplified-chinese
projects[spanish]=dash-spanish
projects[traditional-chinese]=dash-traditional-chinese
projects[vietnamese]=dash-vietnamese

# Loop through each project and fetch build status
for lang in "${!projects[@]}"; do
    slug=${projects[$lang]}
    echo -e "\e[1m$lang ($slug) build status...\e[0m"
    
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
        elif [[ "$line" == *"Status: Installing"* ]]; then
            echo -e "  \e[1;32m$line\e[0m"  # Highlight in green            
        else
          echo " $line"
        fi
    done
done