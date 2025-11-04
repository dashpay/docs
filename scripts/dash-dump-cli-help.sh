#!/usr/bin/env bash
#
# dump-dash-cli-help.sh
#
# Iterate over all dash-cli RPC commands (including subcommands where applicable)
# and dump their help text into:
#   - A single readable text file (OUT)
#   - Optionally, a newline-delimited JSON file (OUT_JSONL) for machine parsing
#
# Usage:
#   chmod +x dump-dash-cli-help.sh
#   ./dump-dash-cli-help.sh
#
# Overrides:
#   CLI=/path/to/dash-cli NET_ARGS="-testnet" OUT="help.txt" ./dump-dash-cli-help.sh
#
# Dependencies:
#   Needs a running Dash node with RPC access (same as using dash-cli manually).
#
set -euo pipefail

# ---- Config (override via env vars when running) -----------------------------
CLI="${CLI:-$HOME/code/dash/src/dash-cli}"    # Path to dash-cli executable
NET_ARGS="${NET_ARGS:--testnet}"               # e.g. "", "-testnet", "-regtest"
OUT="${OUT:-dash-cli-help-$(date -u +%Y%m%dT%H%M%SZ).txt}"  # Text output file
OUT_JSONL="${OUT_JSONL:-dash-cli-help-$(date -u +%Y%m%dT%H%M%SZ).jsonl}" # JSONL output
FORMAT_JSONL="${FORMAT_JSONL:-1}" # set to 0 to disable JSONL output
# ------------------------------------------------------------------------------

# Sanity check on the CLI binary
if [[ ! -x "$CLI" ]]; then
  echo "error: CLI not found or not executable at: $CLI" >&2
  exit 1
fi

# Capture version text (non-fatal if it fails)
# Extract schema like "v23.0.0-rc.3" from dash-cli -version
full_version="$("$CLI" $NET_ARGS -version 2>/dev/null || true)"
VERSION="$(sed -n 's/.*v\([0-9][^ ]*\).*/\1/p' <<< "$full_version")"

# Update output filenames to include version (if available)
if [[ -n "$VERSION" ]]; then
  OUT="dash-cli-help-${VERSION}-$(date -u +%Y%m%dT%H%M%SZ).txt"
  OUT_JSONL="dash-cli-help-${VERSION}-$(date -u +%Y%m%dT%H%M%SZ).jsonl"
fi


# Grab the full top-level help (one call, reused)
TOP_HELP="$("$CLI" $NET_ARGS help 2>/dev/null | sed 's/\r$//')"

# Build list of top-level commands and their "signature tail"
declare -A CMD_TAIL=()
mapfile -t CMDS < <(
  awk '
    /^[a-z][a-z0-9_-]*/ {
      cmd=$1
      if (!seen[cmd]++) print cmd
    }
  ' <<<"$TOP_HELP" | sort -u
)

# Fill the tail map: command -> "arguments signature"
while IFS=$'\t' read -r cmd tail; do
  [[ -n "${cmd:-}" ]] || continue
  CMD_TAIL["$cmd"]="$tail"
done < <(
  awk '
    /^[a-z][a-z0-9_-]*/ {
      cmd=$1
      sub($1"[ \t]*","")
      print cmd "\t" $0
    }
  ' <<<"$TOP_HELP"
)

if ((${#CMDS[@]} == 0)); then
  echo "error: could not parse any commands from top-level help" >&2
  exit 1
fi

# Detect "family" RPCs by the single argument named "command"
is_family() {
  local tail="${1:-}"
  # Exactly one arg named "command"
  [[ "$tail" =~ ^\"command\"([[:space:]]*)$ ]]
}

# Append a help block to the OUTPUT
append_help () {
  local title="$1"; shift
  {
    echo
    echo "================================================================================"
    echo "## $title"
    echo "--------------------------------------------------------------------------------"
    "$CLI" $NET_ARGS help "$@" 2>&1 || echo "(error retrieving help for: $*)"
  } >> "$OUT"
}

# Capture help output as a string (without writing to file yet)
capture_help () {
  "$CLI" $NET_ARGS help "$@" 2>&1 | sed 's/\r$//'
}

# Parse "Available commands:" section from `help <cmd>`
discover_subcommands () {
  local cmd="$1"
  local txt
  txt="$("$CLI" $NET_ARGS help "$cmd" 2>/dev/null | sed 's/\r$//')" || return 0

  awk '
    BEGIN { insec=0 }
    /^Available commands:/ { insec=1; next }
    /^Arguments:/ { insec=0 }
    insec==1 {
      # Stop if a blank line separates sections in some versions
      if ($0 ~ /^[[:space:]]*$/) next
      # Lines look like:
      #   register                 - Create and send ProTx to network
      #   update_service_evo       - Create ...
      #   (sometimes with extra spaces or tabs)
      if ($0 ~ /^[[:space:]]*[A-Za-z0-9_-]+/) {
        line=$0
        sub(/^[[:space:]]*/, "", line)
        # Split on " - " (dash with spaces) first; fallback to first field
        n = split(line, parts, /[[:space:]]+-[[:space:]]+/)
        if (n >= 1) {
          subcmd = parts[1]
        } else {
          # fallback: first whitespace-delimited token
          split(line, parts2, /[[:space:]]+/)
          subcmd = parts2[1]
        }
        # trim any trailing colon just in case
        sub(/:$/, "", subcmd)
        if (subcmd != "") print subcmd
      }
    }
  ' <<<"$txt" | sort -u
}

# -------------------- Write Header -----------------------
{
  echo "# dash-cli help dump"
  echo
  echo "CLI: $CLI"
  echo "Network args: $NET_ARGS"
  [[ -n "$VERSION" ]] && echo "Version: $VERSION"
  echo "Generated: $(date -u '+%Y-%m-%d %H:%M:%SZ')"
  echo
  echo "## Top-level command list (${#CMDS[@]})"
  for c in "${CMDS[@]}"; do
    echo "$c ${CMD_TAIL[$c]}"
  done
  echo
} > "$OUT"

# -------------------- Main loop --------------------------
for cmd in "${CMDS[@]}"; do
  help_raw="$(capture_help "$cmd")"
  append_help "$cmd" "$cmd"
  echo "wrote help for $cmd" >&2

  # JSONL output (root command)
  if [[ "$FORMAT_JSONL" -eq 1 ]]; then
    help_sha256=$(printf '%s' "$help_raw" | sha256sum | awk '{print $1}')
    jq -cn \
      --arg cmd "$cmd" \
      --arg version "$VERSION" \
      --arg net "$NET_ARGS" \
      --arg help "$help_raw" \
      --arg qual "$cmd" \
      --arg tail "${CMD_TAIL[$cmd]}" \
      --arg hash "$help_sha256" \
      --argjson isfam "$([[ $(is_family "${CMD_TAIL[$cmd]}") ]] && echo true || echo false)" \
      '{
         command: $cmd,
         subcommand: null,
         qualified: $qual,
         signature_tail: $tail,
         is_family: $isfam,
         help_raw: $help,
         help_sha256: $hash,
         version: $version,
         network_args: $net,
         generated_utc: now|strftime("%Y-%m-%dT%H:%M:%SZ")
       }' >> "$OUT_JSONL"
  fi

  # Check if this is a family RPC
  if is_family "${CMD_TAIL[$cmd]}"; then
    mapfile -t SUBS < <(discover_subcommands "$cmd" || true)
    if ((${#SUBS[@]} > 0)); then
      {
        echo
        echo "### Subcommands for '$cmd' (${#SUBS[@]}):"
        printf '%s\n' "${SUBS[@]}"
        echo
      } >> "$OUT"

      for sub in "${SUBS[@]}"; do
        help_sub="$(capture_help "$cmd" "$sub")"
        append_help "$cmd $sub" "$cmd" "$sub"
        echo "  wrote help for $cmd $sub" >&2

        # JSONL output (subcommand)
        if [[ "$FORMAT_JSONL" -eq 1 ]]; then
          help_sha256_sub=$(printf '%s' "$help_sub" | sha256sum | awk '{print $1}')
          jq -cn \
            --arg cmd "$cmd" \
            --arg sub "$sub" \
            --arg version "$VERSION" \
            --arg net "$NET_ARGS" \
            --arg help "$help_sub" \
            --arg qual "$cmd $sub" \
            --arg tail "${CMD_TAIL[$cmd]}" \
            --arg hash "$help_sha256_sub" \
            '{
               command: $cmd,
               subcommand: $sub,
               qualified: $qual,
               signature_tail: $tail,
               is_family: true,
               help_raw: $help,
               help_sha256: $hash,
               version: $version,
               network_args: $net,
               generated_utc: now|strftime("%Y-%m-%dT%H:%M:%SZ")
             }' >> "$OUT_JSONL"
        fi
      done
    else
      {
        echo
        echo "### Subcommands for '$cmd': none discovered"
        echo
      } >> "$OUT"
    fi
  fi
done

echo "Done. Wrote $(wc -l < "$OUT") lines to $OUT" >&2
if [[ "$FORMAT_JSONL" -eq 1 ]]; then
  echo "Also wrote JSONL to $OUT_JSONL" >&2
fi
