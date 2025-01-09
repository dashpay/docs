#!/bin/bash
# Parse the output of Dash Core help into the format for the
# docs/core/dashcore/wallet-arguments-and-commands-dash-* files. The script output can be copied
# into the relevant sections of those files to update them.

# Examples:
# dash-qt --help-debug | ./scripts/core-help-parsing.sh
# dash-cli --help | ./scripts/core-help-parsing.sh

# Ensure input is being piped
if [ -t 0 ]; then
    echo "Error: This script only accepts piped input. Try piping the output of 'dashd --help' into it." >&2
    exit 1
fi

# Read the piped input and process sections
in_code_block=false
while IFS= read -r line; do
    # Match section headers (e.g., "Options:")
    if [[ "$line" =~ ^[A-Za-z].*:$ ]]; then
        # Close the previous code block if it's open
        if [[ "$in_code_block" == "true" ]]; then
            echo '```'
            echo
        fi

        # Write the new section heading
        echo "### ${line%:}"
        echo
        echo '```text'
        in_code_block=true
    else
        # Append all lines (including blank ones) to the current section's code block
        if [[ "$in_code_block" == "true" ]]; then
            echo "$line"
        fi
    fi
done

# Close the last code block if it's open
if [[ "$in_code_block" == "true" ]]; then
    echo '```'
fi
