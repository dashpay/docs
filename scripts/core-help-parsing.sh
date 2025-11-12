#!/bin/bash
# Parse the output of Dash Core help into the format for the
# docs/core/dashcore/wallet-arguments-and-commands-dash-* files. The script output can be copied
# into the relevant sections of those files to update them.

# Examples:
# dash-qt --help-debug | ./scripts/core-help-parsing.sh
# dash-cli --help | ./scripts/core-help-parsing.sh
# dashd --help | ./scripts/core-help-parsing.sh --update docs/core/dashcore/wallet-arguments-and-commands-dashd.md

# Parse command-line arguments
UPDATE_FILE=""
SHOW_HELP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --update)
            UPDATE_FILE="$2"
            shift 2
            ;;
        --help|-h)
            SHOW_HELP=true
            shift
            ;;
        *)
            echo "Error: Unknown option '$1'" >&2
            exit 1
            ;;
    esac
done

# Show help if requested
if [[ "$SHOW_HELP" == "true" ]]; then
    cat << 'EOF'
Usage: COMMAND --help | ./scripts/core-help-parsing.sh [OPTIONS]

Parse Dash Core help output into formatted markdown.

Options:
  --update FILE    Update FILE in-place, replacing content from ### Options
                   until the next # or ## heading
  --help, -h       Show this help message

Examples:
  # Output to stdout (default)
  dashd --help | ./scripts/core-help-parsing.sh

  # Update file in-place
  dashd --help | ./scripts/core-help-parsing.sh --update docs/core/dashcore/wallet-arguments-and-commands-dashd.md
EOF
    exit 0
fi

# Ensure input is being piped
if [ -t 0 ]; then
    echo "Error: This script only accepts piped input. Try piping the output of 'dashd --help' into it." >&2
    exit 1
fi

# Function to process help input and format as markdown
process_help_output() {
    local in_code_block=false
    local current_section=""
    while IFS= read -r line; do
        # Match section headers (e.g., "Options:")
        if [[ "$line" =~ ^[A-Za-z].*:$ ]]; then
            # Extract section name
            local section_name="${line%:}"

            # Skip the "Usage" section as it's typically already documented manually
            if [[ "$section_name" == "Usage" ]]; then
                current_section="Usage"
                in_code_block=false
                continue
            fi

            # Close the previous code block if it's open
            if [[ "$in_code_block" == "true" ]]; then
                echo '```'
                echo
            fi

            # Write the new section heading
            echo "### $section_name"
            echo
            echo '```text'
            in_code_block=true
            current_section="$section_name"
        else
            # Append all lines (including blank ones) to the current section's code block
            # But skip lines if we're in the Usage section
            if [[ "$in_code_block" == "true" && "$current_section" != "Usage" ]]; then
                echo "$line"
            fi
        fi
    done

    # Close the last code block if it's open
    if [[ "$in_code_block" == "true" ]]; then
        echo '```'
    fi
}

# If --update flag is used, update the file in-place
if [[ -n "$UPDATE_FILE" ]]; then
    # Check if file exists
    if [[ ! -f "$UPDATE_FILE" ]]; then
        echo "Error: File '$UPDATE_FILE' not found." >&2
        exit 1
    fi

    # Read and validate the input first
    raw_input=$(cat)

    # Check if input is empty
    if [[ -z "$raw_input" ]]; then
        echo "Error: No help output received. File not updated." >&2
        exit 1
    fi

    # Check if input looks like an error message (starts with "Error", "Invalid", "Unknown", etc.)
    # Only check the first few lines to avoid false positives in actual help text
    first_lines=$(echo "$raw_input" | head -n 3)
    if echo "$first_lines" | grep -qE "^(Error|Invalid|Unknown|Usage error)"; then
        echo "Error: Help command returned an error. File not updated." >&2
        echo "Output received:" >&2
        echo "$raw_input" >&2
        exit 1
    fi

    # Format the input
    formatted_output=$(echo "$raw_input" | process_help_output)

    # Double-check formatted output isn't empty
    if [[ -z "$formatted_output" ]]; then
        echo "Error: Formatting produced no output. File not updated." >&2
        exit 1
    fi

    # Create a temporary file
    temp_file=$(mktemp)

    # Process the target file
    found_options=false
    found_end=false
    while IFS= read -r line; do
        # If we haven't found ### Options yet, keep the line
        if [[ "$found_options" == "false" ]]; then
            if [[ "$line" =~ ^###\ Options$ ]]; then
                found_options=true
                # Insert the formatted help output (which includes ### Options)
                echo "$formatted_output" >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        # If we found ### Options, skip lines until we find # or ##
        elif [[ "$found_end" == "false" ]]; then
            if [[ "$line" =~ ^##?[[:space:]] ]]; then
                found_end=true
                echo "$line" >> "$temp_file"
            fi
            # Skip all other lines between ### Options and next # or ##
        else
            # After finding the end marker, keep all remaining lines
            echo "$line" >> "$temp_file"
        fi
    done < "$UPDATE_FILE"

    # Replace the original file
    mv "$temp_file" "$UPDATE_FILE"
    echo "Successfully updated $UPDATE_FILE" >&2
else
    # Default behavior: output to stdout
    cat | process_help_output
fi
