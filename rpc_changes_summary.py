#!/usr/bin/env python3
"""
Generate executive summary of RPC changes between versions.
"""

import json
import re

def parse_jsonl(filepath):
    """Parse JSONL file and return dict of command -> data"""
    commands = {}
    with open(filepath, 'r') as f:
        for line in f:
            if line.strip():
                data = json.loads(line)
                if 'metadata' in data:
                    continue
                commands[data['command']] = data
    return commands

def find_deprecated_items(help_text):
    """Find all deprecated items in help text"""
    deprecated = []
    lines = help_text.split('\n')
    for line in lines:
        if '(DEPRECATED' in line.upper():
            # Extract the field name or description
            deprecated.append(line.strip())
    return deprecated

def extract_signature(help_text):
    """Extract the command signature from help text"""
    lines = help_text.split('\n')
    if lines:
        return lines[0].strip()
    return ""

def categorize_changes(old_commands, new_commands):
    """Categorize all changes between versions"""
    old_cmds = set(old_commands.keys())
    new_cmds = set(new_commands.keys())

    changes = {
        'added': sorted(new_cmds - old_cmds),
        'removed': sorted(old_cmds - new_cmds),
        'modified': {},
        'newly_deprecated': {},
        'signature_changed': [],
    }

    # Analyze common commands
    common = sorted(old_cmds & new_cmds)
    for cmd in common:
        old_help = old_commands[cmd].get('help_raw', '')
        new_help = new_commands[cmd].get('help_raw', '')

        # Check if modified
        if old_commands[cmd].get('help_sha256') != new_commands[cmd].get('help_sha256'):
            old_sig = extract_signature(old_help)
            new_sig = extract_signature(new_help)

            # Check for deprecations
            old_dep = set(find_deprecated_items(old_help))
            new_dep = set(find_deprecated_items(new_help))
            newly_dep = new_dep - old_dep

            if newly_dep:
                changes['newly_deprecated'][cmd] = list(newly_dep)

            # Check for signature changes
            if old_sig != new_sig:
                changes['signature_changed'].append({
                    'command': cmd,
                    'old': old_sig,
                    'new': new_sig
                })

            # Store all modifications
            changes['modified'][cmd] = {
                'old_sig': old_sig,
                'new_sig': new_sig,
                'sig_changed': old_sig != new_sig,
                'has_deprecations': len(newly_dep) > 0
            }

    return changes

def generate_summary(old_file, new_file, old_version, new_version):
    """Generate executive summary"""
    print(f"Parsing {old_file}...")
    old_commands = parse_jsonl(old_file)
    print(f"Found {len(old_commands)} commands in {old_version}")

    print(f"\nParsing {new_file}...")
    new_commands = parse_jsonl(new_file)
    print(f"Found {len(new_commands)} commands in {new_version}")

    changes = categorize_changes(old_commands, new_commands)

    # Generate summary report
    report = []
    report.append(f"# Dash Core RPC Changes: {old_version} → {new_version}")
    report.append(f"\n**Executive Summary**\n")

    # Key Statistics
    report.append("## Key Statistics\n")
    report.append(f"- **Total RPCs in {old_version}:** {len(old_commands)}")
    report.append(f"- **Total RPCs in {new_version}:** {len(new_commands)}")
    report.append(f"- **Added RPCs:** {len(changes['added'])}")
    report.append(f"- **Removed RPCs:** {len(changes['removed'])}")
    report.append(f"- **Modified RPCs:** {len(changes['modified'])}")
    report.append(f"- **RPCs with signature changes:** {len(changes['signature_changed'])}")
    report.append(f"- **RPCs with new deprecations:** {len(changes['newly_deprecated'])}")
    report.append("")

    # Major Changes Section
    report.append("## Major Changes\n")

    # Added RPCs
    if changes['added']:
        report.append(f"### Added RPCs ({len(changes['added'])})\n")
        for cmd in changes['added']:
            desc = new_commands[cmd].get('help_raw', '').split('\n')
            sig = desc[0] if desc else cmd
            report.append(f"- **`{cmd}`**")
            if len(desc) > 1:
                report.append(f"  - {desc[1].strip()}")
            report.append("")

    # Removed RPCs
    if changes['removed']:
        report.append(f"### Removed RPCs ({len(changes['removed'])})\n")
        for cmd in changes['removed']:
            desc = old_commands[cmd].get('help_raw', '').split('\n')
            report.append(f"- **`{cmd}`**")
            if len(desc) > 1:
                report.append(f"  - {desc[1].strip()}")
        report.append("")

    # Signature Changes (Most Important)
    if changes['signature_changed']:
        report.append(f"### RPCs with Signature Changes ({len(changes['signature_changed'])})\n")
        report.append("*These commands have changes to their parameters or calling format*\n")
        for change in changes['signature_changed']:
            report.append(f"#### `{change['command']}`\n")
            report.append("**Old signature:**")
            report.append(f"```")
            report.append(change['old'])
            report.append(f"```\n")
            report.append("**New signature:**")
            report.append(f"```")
            report.append(change['new'])
            report.append(f"```\n")

    # New Deprecations
    if changes['newly_deprecated']:
        report.append(f"### New Deprecation Notices ({len(changes['newly_deprecated'])})\n")
        report.append("*These commands or fields are newly marked as deprecated*\n")
        for cmd, deps in sorted(changes['newly_deprecated'].items()):
            report.append(f"#### `{cmd}`\n")
            for dep in deps:
                # Clean up the deprecation notice
                dep_clean = dep.strip()
                report.append(f"- {dep_clean}")
            report.append("")

    # Modified RPCs without signature changes
    modified_no_sig = {k: v for k, v in changes['modified'].items()
                       if not v['sig_changed'] and not v['has_deprecations']}
    if modified_no_sig:
        report.append(f"### Other Modified RPCs ({len(modified_no_sig)})\n")
        report.append("*These commands have changes to documentation, result format, or minor details*\n")
        for cmd in sorted(modified_no_sig.keys()):
            report.append(f"- `{cmd}`")
        report.append("")

    # Key Observations
    report.append("## Key Observations\n")

    # Platform/EvoNode changes
    platform_related = [cmd for cmd in changes['signature_changed']
                       if 'platform' in cmd['new'].lower() or 'evo' in cmd['new'].lower()]
    if platform_related:
        report.append(f"### Platform/EvoNode Changes ({len(platform_related)})")
        report.append("Several commands related to Platform and EvoNodes have been updated:")
        for change in platform_related:
            report.append(f"- `{change['command']}`")
        report.append("")

    # Deprecated service field
    service_deprecated = [cmd for cmd, deps in changes['newly_deprecated'].items()
                         if any('service' in dep.lower() for dep in deps)]
    if service_deprecated:
        report.append("### Deprecated 'service' Field")
        report.append("The following commands now deprecate the 'service' field (IP:PORT format),")
        report.append("moving to a new 'addresses' structure:")
        for cmd in service_deprecated:
            report.append(f"- `{cmd}`")
        report.append("")

    # BLS legacy deprecation
    if 'bls' in changes['newly_deprecated']:
        report.append("### BLS Legacy Scheme Deprecated")
        report.append("The legacy BLS scheme is now deprecated in the `bls` command.")
        report.append("This requires the `-deprecatedrpc=legacy_mn` flag to use.")
        report.append("")

    return '\n'.join(report)

if __name__ == '__main__':
    old_file = '/home/phez/code/dashpay-docs/dash-cli-help-22.1.3-20251104T214929Z.jsonl'
    new_file = '/home/phez/code/dashpay-docs/dash-cli-help-23.0.0-rc.3-20251104T213450Z.jsonl'

    summary = generate_summary(old_file, new_file, '22.1.3', '23.0.0-rc.3')

    output_file = '/home/phez/code/dashpay-docs/rpc-changes-summary-22.1.3-to-23.0.0-rc.3.md'
    with open(output_file, 'w') as f:
        f.write(summary)

    print(f"\n\nSummary generated: {output_file}")
    print("\n" + "="*80)
    print(summary)
