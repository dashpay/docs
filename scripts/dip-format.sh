#!/bin/bash

# Directory containing the files
dir='_dips'

echo "Starting to process files in $dir..."

# Add start of toctree
content=$(cat <<EOL

\`\`\`{toctree}
:maxdepth: 2
:titlesonly: 
:caption: DIPs
:hidden:

EOL
)

echo "$content" >> "$dir"/README.md

for filename in "$dir"/*.md; do
    if [ $(basename "$filename") = "README.md" ]
    then
      echo "Skipping README.md"
      continue
    fi

    echo "Processing $filename..."

    # Extract DIP number
    full_dip_num=$(grep '^\s*DIP:' "$filename" | awk -F: '{print $2}' | sed 's/^ *//'  | tr -d '\r')
    dip="${full_dip_num#"${full_dip_num%%[!0]*}"}"

    # Extract title
    title=$(grep '^\s*Title:' "$filename" | awk -F: '{print $2}' | sed 's/^ *//'  | tr -d '\r')

    # Combine to make heading
    heading="# $dip - $title"
    echo "Heading $heading..."

    # Create temp file
    tempfile=$(mktemp)

    # Write heading to temp file
    echo -e "$heading\n" > "$tempfile"

    # Append original file contents to temp file
    cat "$filename" >> "$tempfile"

    # Move temp file to original file
    mv "$tempfile" "$filename"

    # Write the filename to the toctree
    echo "dip-$full_dip_num" >> "$dir"/README.md
done

# Close out the toctree
closing_content=$(cat <<EOL
\`\`\`
EOL
)

echo "$closing_content" >> "$dir"/README.md

# Output the updated readme
cat "$dir"/README.md

echo "Finished processing files."
