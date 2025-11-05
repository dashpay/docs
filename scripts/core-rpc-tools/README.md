# Dash Core RPC Documentation Tools

This directory contains tools to assist with updating Dash Core RPC documentation when new versions are released.

## Overview

These scripts automate the process of:

1. Extracting all RPC command help text from Dash Core
2. Comparing RPC definitions between versions
3. Generating human-readable change summaries

This workflow helps documentation maintainers quickly identify what changed between Dash Core versions and update the RPC reference docs accordingly.

## Prerequisites

### Required Software

* **dash-cli**: The Dash Core command-line interface (from your local Dash Core build or installation)
* **Running Dash node**: A Dash node with RPC access (testnet, mainnet, or regtest)
* **Python 3**: For running the comparison script
* **jq**: For JSON processing (used by dump-cli-help.sh)
* **Bash**: For running the shell script

### Setup

1. Ensure your Dash node is running and synced
2. Verify dash-cli can connect to your node:

   ```bash
   dash-cli -testnet getblockchaininfo
   ```

3. Install jq if not already installed:

   ```bash
   # Ubuntu/Debian
   sudo apt-get install jq

   # macOS
   brew install jq
   ```

## Complete Workflow

### Step 1: Dump RPC Help for the Old Version

First, dump all RPC help text from the version you're upgrading FROM:

```bash
cd scripts/core-rpc-tools

# Set path to your dash-cli for version 22.1.3 (example)
CLI="$HOME/dashcore-22.1.3/bin/dash-cli" NET_ARGS="-testnet" ./dump-cli-help.sh
```

This generates two files:

* `dash-cli-help-22.1.3-<timestamp>.txt` - Human-readable text file
* `dash-cli-help-22.1.3-<timestamp>.jsonl` - Machine-readable JSONL file

### Step 2: Dump RPC Help for the New Version

Switch to the new Dash Core version and dump its help:

```bash
# Restart your node with the new version
# Then dump help again
cd ~/code/dashpay-docs/scripts/core-rpc-tools
CLI="$HOME/dashcore-23.0.0/bin/dash-cli" NET_ARGS="-testnet" ./dump-cli-help.sh
```

This generates:

* `dash-cli-help-23.0.0-<timestamp>.txt`
* `dash-cli-help-23.0.0-<timestamp>.jsonl`

### Step 3: Generate Change Summary

Compare the two versions and generate a detailed change report:

```bash
# Pass the two JSONL files as command-line arguments
python3 generate-rpc-change-summary.py \
  dash-cli-help-22.1.3-<timestamp>.jsonl \
  dash-cli-help-23.0.0-<timestamp>.jsonl
```

This generates:

* `rpc-changes-summary-22.1.3-to-23.0.0.md` - Comprehensive change summary

## Script Details

### dump-cli-help.sh

**Purpose**: Extracts help text for all RPC commands and subcommands from dash-cli.

**Usage**:

```bash
./dump-cli-help.sh
```

**Configuration via Environment Variables**:

```bash
# Custom dash-cli path
CLI="/path/to/dash-cli" ./dump-cli-help.sh

# Different network
NET_ARGS="" ./dump-cli-help.sh  # mainnet
```

**How It Works**:

1. Runs `dash-cli help` to get the full command list
2. Iterates through each command and captures `dash-cli help <command>`
3. Detects "family" RPCs (commands with subcommands like `protx`, `bls`, `coinjoin`)
4. For family RPCs, discovers and captures help for each subcommand
5. Outputs both human-readable text and structured JSONL format
6. Automatically extracts version from `dash-cli -version` and includes it in filenames

**Output Files**:

* **Text file** (`.txt`): Formatted for human reading, with headers and separators
* **JSONL file** (`.jsonl`): One JSON object per line, structured for machine parsing
  * Metadata header with version, network, timestamp
  * One record per command/subcommand with:
    * `command`: Top-level command name
    * `subcommand`: Subcommand name (null for root commands)
    * `qualified`: Full command string (e.g., "protx register")
    * `signature_tail`: Argument signature from help list
    * `is_family`: Whether this is a family RPC with subcommands
    * `help_raw`: Complete help text
    * `help_sha256`: Hash for detecting changes

### generate-rpc-change-summary.py

**Purpose**: Compares two JSONL help dumps and generates a detailed change summary.

**Usage**:

```bash
python3 generate-rpc-change-summary.py <old_version.jsonl> <new_version.jsonl>
```

**Examples**:

```bash
# Compare version 22.1.3 to 23.0.0
python3 generate-rpc-change-summary.py \
  dash-cli-help-22.1.3-20251104T214929Z.jsonl \
  dash-cli-help-23.0.0-20251104T213450Z.jsonl

# The script automatically extracts version info from the JSONL metadata
# and creates an appropriately named output file
```

## Output Files Reference

After running the complete workflow, you'll have these files:

| File | Purpose | Format |
|------|---------|--------|
| `dash-cli-help-{version}-{timestamp}.txt` | Human-readable help dump | Plain text with headers |
| `dash-cli-help-{version}-{timestamp}.jsonl` | Machine-readable help dump | JSONL (one JSON per line) |
| `rpc-changes-summary-{oldver}-to-{newver}.md` | Change summary report | Markdown |

**Recommended versioning**: Keep all JSONL files in version control to track historical changes:

```bash
git add dash-cli-help-*.jsonl
git add rpc-changes-summary-*.md
git commit -m "feat: add RPC change analysis for <version>"
```
