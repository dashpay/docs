#!/usr/bin/env python3
"""
Generate executive summary of RPC changes between versions.
"""

import argparse
import json
import re
from collections import defaultdict

# ---------- JSONL parsing & metadata ----------

def read_metadata(filepath):
    """
    Read first JSONL line that contains {"metadata": {...}} and return that dict.
    Returns {} if not found.
    """
    with open(filepath, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                data = json.loads(line)
            except json.JSONDecodeError:
                continue
            meta = data.get("metadata")
            if isinstance(meta, dict):
                return meta
    return {}

def parse_jsonl(filepath):
    """
    Parse JSONL file and return dict: qualified -> record
    Skips metadata lines.
    """
    cmds = {}
    with open(filepath, 'r') as f:
        for line in f:
            if not line.strip():
                continue
            data = json.loads(line)
            if 'metadata' in data:
                continue
            # Use 'qualified' so subcommands aren't overwritten
            key = data.get('qualified') or data.get('command')
            if not key:
                continue
            cmds[key] = data
    return cmds

# ---------- Text helpers ----------

_DEPRECATION_RE = re.compile(r'\( *DEPRECATED\b[^)]*\)', re.IGNORECASE)
_REPLACED_WITH_RE = re.compile(r'\b(replaced\s+with)\b[: ]+(?P<replacement>.+)$', re.IGNORECASE)
_ARGUMENTS_HDR_RE = re.compile(r'^\s*Arguments:\s*$', re.IGNORECASE)
_RESULT_HDR_RE = re.compile(r'^\s*Result\b', re.IGNORECASE)

# Lines like:   "field" : type, (qualifiers) description
_RESULT_FIELD_RE = re.compile(r'^\s*"(?P<name>[^"]+)"\s*:\s*')

# Try to extract a concise "signature" = first non-empty line
def extract_signature(help_text: str) -> str:
    for line in help_text.splitlines():
        s = line.strip()
        if s:
            return s
    return ""

def find_deprecated_items(help_text: str):
    """Return list of lines that contain '(DEPRECATED...)', case-insensitive."""
    hits = []
    for line in help_text.splitlines():
        if _DEPRECATION_RE.search(line):
            hits.append(line.strip())
    return hits

def find_replacements(help_text: str):
    """
    Find "replaced with X" hints, returned as list of (line, replacement) tuples.
    Useful for mapping old->new field names.
    """
    items = []
    for line in help_text.splitlines():
        m = _REPLACED_WITH_RE.search(line)
        if m:
            items.append((line.strip(), m.group('replacement').strip()))
    return items

def parse_arguments_section(help_text: str):
    """
    Parse 'Arguments:' block into a set of argument keys and a dict for detail.
    Heuristics: lines in the arguments block often start with '1. name  (...)' or quoted names.
    We’ll extract names conservatively.
    """
    lines = help_text.splitlines()
    in_args = False
    args = []
    for i, line in enumerate(lines):
        if _ARGUMENTS_HDR_RE.match(line):
            in_args = True
            continue
        if in_args:
            # Stop if we hit an empty line or another header-like thing
            if not line.strip():
                break
            if _RESULT_HDR_RE.match(line):
                break
            # Try patterns:
            # 1. number-dot form:  1. argname (type, optional, ...)
            m = re.match(r'^\s*\d+\.\s*([A-Za-z0-9_\[\]".-]+)', line)
            if m:
                name = m.group(1).strip().strip('"')
                args.append(name)
                continue
            # 2. quoted field as an argument name
            m2 = re.match(r'^\s*"([^"]+)"\s*[:)]', line)
            if m2:
                args.append(m2.group(1).strip())
                continue
            # 3. bare token at start (fallback)
            m3 = re.match(r'^\s*([A-Za-z0-9_".-]+)\s', line)
            if m3 and not line.strip().startswith('{'):
                token = m3.group(1).strip('"')
                args.append(token)
    # Normalize + dedup
    return list(dict.fromkeys(args))

def parse_result_fields(help_text: str):
    """
    Parse 'Result' block for JSON-style field names.
    Collect quoted keys at start-of-line with colon.
    """
    lines = help_text.splitlines()
    in_result = False
    fields = []
    for line in lines:
        if _RESULT_HDR_RE.match(line):
            in_result = True
            continue
        if in_result:
            # Heuristic stop: out of structured result section if code fence or blank block end
            if line.strip().startswith('Examples:'):
                break
            m = _RESULT_FIELD_RE.match(line)
            if m:
                fields.append(m.group('name').strip())
    return list(dict.fromkeys(fields))

def extract_signature_args(signature: str):
    """
    Heuristic arg name extraction from the signature line.
    We capture tokens inside quotes, like "label", "address", or ["address",...]
    """
    quoted = re.findall(r'"([^"]+)"', signature)
    # Also catch bracketed array arg names like ["address",...]
    bracket_names = re.findall(r'\[\s*"([^"]+)"', signature)
    tokens = quoted + bracket_names
    # Dedup preserving order
    return list(dict.fromkeys(tokens))

# ---------- Change categorization ----------

def compare_structures(old_help: str, new_help: str):
    """Return a dict with structured diffs between two help texts."""
    old_sig = extract_signature(old_help)
    new_sig = extract_signature(new_help)

    old_sig_args = set(extract_signature_args(old_sig))
    new_sig_args = set(extract_signature_args(new_sig))

    old_args = set(parse_arguments_section(old_help))
    new_args = set(parse_arguments_section(new_help))

    old_fields = set(parse_result_fields(old_help))
    new_fields = set(parse_result_fields(new_help))

    old_dep = set(find_deprecated_items(old_help))
    new_dep = set(find_deprecated_items(new_help))
    newly_dep = sorted(new_dep - old_dep)

    repl = find_replacements(new_help)

    return {
        "old_sig": old_sig,
        "new_sig": new_sig,
        "signature_changed": (old_sig != new_sig),
        "sig_args_added": sorted(new_sig_args - old_sig_args),
        "sig_args_removed": sorted(old_sig_args - new_sig_args),

        "args_added": sorted(new_args - old_args),
        "args_removed": sorted(old_args - new_args),

        "result_fields_added": sorted(new_fields - old_fields),
        "result_fields_removed": sorted(old_fields - new_fields),

        "newly_deprecated": newly_dep,
        "replacements": repl,
    }

def categorize_changes(old_commands, new_commands):
    """Compute added/removed/modified and categorize modified details."""
    old_keys = set(old_commands.keys())
    new_keys = set(new_commands.keys())

    changes = {
        "added": sorted(new_keys - old_keys),
        "removed": sorted(old_keys - new_keys),
        "modified": {},  # key -> detail dict
    }

    common = sorted(old_keys & new_keys)
    for key in common:
        old = old_commands[key]
        new = new_commands[key]
        if old.get('help_sha256') == new.get('help_sha256'):
            continue  # unchanged

        detail = compare_structures(old.get('help_raw', ''), new.get('help_raw', ''))

        # classify reason (multiple may apply; keep a compact list)
        reasons = []
        if detail["signature_changed"] or detail["sig_args_added"] or detail["sig_args_removed"]:
            reasons.append("signature")
        if detail["args_added"] or detail["args_removed"]:
            reasons.append("arguments")
        if detail["result_fields_added"] or detail["result_fields_removed"]:
            reasons.append("result")
        if detail["newly_deprecated"]:
            reasons.append("deprecation")
        if not reasons:
            reasons.append("docs-only")

        detail["reasons"] = reasons
        changes["modified"][key] = detail

    return changes

# ---------- Reporting helpers ----------

def render_change_details(key, d, report):
    """Append all detected details for an RPC to the report (under one heading)."""
    report.append(f"#### `{key}`\n")

    # Signature delta (show blocks only if signature string changed)
    if d["old_sig"] or d["new_sig"]:
        if d["old_sig"] != d["new_sig"]:
            report.append("**Old signature:**")
            report.append("\n```text")
            report.append(d["old_sig"])
            report.append("```\n")
            report.append("**New signature:**")
            report.append("\n```text")
            report.append(d["new_sig"])
            report.append("```\n")

    # Build grouped changes with nested bullets
    groups = []

    # Signature-arg tokens (from the signature line)
    sig_parts = []
    if d["sig_args_added"]:
        sig_parts.append(f"➕ {', '.join(d['sig_args_added'])}")
    if d["sig_args_removed"]:
        sig_parts.append(f"➖ {', '.join(d['sig_args_removed'])}")
    if sig_parts:
        groups.append(("signature", sig_parts))

    # Arguments section deltas (from Arguments: block)
    arg_parts = []
    if d["args_added"]:
        arg_parts.append(f"➕ {', '.join(d['args_added'])}")
    if d["args_removed"]:
        arg_parts.append(f"➖ {', '.join(d['args_removed'])}")
    if arg_parts:
        groups.append(("args", arg_parts))

    # Result field deltas
    res_parts = []
    if d["result_fields_added"]:
        res_parts.append(f"➕ {', '.join(d['result_fields_added'])}")
    if d["result_fields_removed"]:
        res_parts.append(f"➖ {', '.join(d['result_fields_removed'])}")
    if res_parts:
        groups.append(("result", res_parts))

    # Deprecations
    dep_parts = []
    if d["newly_deprecated"]:
        for dep in d["newly_deprecated"]:
            dep_parts.append(f"⚠️ deprecated: {dep}")
        groups.append(("deprecation", dep_parts))

    # Replacements (informational)
    repl_parts = []
    for line, repl in d.get("replacements", []):
        repl_parts.append(f"🔁 replacement hint: {line}")
    if repl_parts:
        groups.append(("notes", repl_parts))

    # Render groups
    for label, parts in groups:
        report.append(f"- {label}:")
        for part in parts:
            report.append(f"  - {part}")
        report.append("")  # spacing after each group

    report.append("")  # final spacing

# ---------- Reporting ----------

def generate_summary(old_file, new_file, old_version=None, new_version=None):
    # Pull metadata versions if present
    old_meta = read_metadata(old_file)
    new_meta = read_metadata(new_file)
    meta_old_ver = (old_meta.get("version") or "").strip()
    meta_new_ver = (new_meta.get("version") or "").strip()

    # Resolve final versions to use for headings/filenames
    old_version = old_version or meta_old_ver or "old"
    new_version = new_version or meta_new_ver or "new"

    print(f"Parsing {old_file} (version: {meta_old_ver or 'n/a'})...")
    old_commands = parse_jsonl(old_file)
    print(f"Found {len(old_commands)} commands in {old_version}")

    print(f"\nParsing {new_file} (version: {meta_new_ver or 'n/a'})...")
    new_commands = parse_jsonl(new_file)
    print(f"Found {len(new_commands)} commands in {new_version}")

    changes = categorize_changes(old_commands, new_commands)

    report = []
    report.append(f"# Dash Core RPC Changes: {old_version} → {new_version}\n")
    report.append("**Executive Summary**\n")

    # Key Stats
    report.append("## Key Statistics\n")
    report.append(f"- **Total RPC entries in {old_version}:** {len(old_commands)}")
    report.append(f"- **Total RPC entries in {new_version}:** {len(new_commands)}")
    report.append(f"- **Added RPC entries:** {len(changes['added'])}")
    report.append(f"- **Removed RPC entries:** {len(changes['removed'])}")
    report.append(f"- **Modified RPC entries:** {len(changes['modified'])}")

    # Reason counts
    reason_counts = defaultdict(int)
    for d in changes["modified"].values():
        for r in d["reasons"]:
            reason_counts[r] += 1
    if reason_counts:
        report.append("- **By reason:** " + ", ".join(f"{k}: {v}" for k, v in sorted(reason_counts.items())))
    report.append("")

    # Major changes
    report.append("## Major Changes\n")

    # Added
    if changes['added']:
        report.append(f"### Added RPCs ({len(changes['added'])})\n")
        for key in changes['added']:
            desc_lines = new_commands[key].get('help_raw', '').splitlines()
            sig = desc_lines[0].strip() if desc_lines else key
            report.append(f"- **`{key}`**")
            if len(desc_lines) > 1 and desc_lines[1].strip():
                report.append(f"  - {desc_lines[1].strip()}")
        report.append("")

    # Removed
    if changes['removed']:
        report.append(f"### Removed RPCs ({len(changes['removed'])})\n")
        for key in changes['removed']:
            desc_lines = old_commands[key].get('help_raw', '').splitlines()
            report.append(f"- **`{key}`**")
            if len(desc_lines) > 1 and desc_lines[1].strip():
                report.append(f"  - {desc_lines[1].strip()}")
        report.append("")

    # Consolidated table for all modified RPCs (excluding docs-only changes)
    if changes['modified']:
        report.append("## Modified RPCs (Consolidated)\n")
        report.append("| RPC | Sig | Args | Result | Deprecation | Change Types |")
        report.append("|-----|:---:|:----:|:------:|:-----------:|--------------|")

        for key, data in sorted(changes['modified'].items()):
            # Skip docs-only changes
            if data["reasons"] == ["docs-only"]:
                continue

            # Columns: checkmarks based on detected changes
            sig = "✔" if data["signature_changed"] or data["sig_args_added"] or data["sig_args_removed"] else ""
            args = "✔" if data["args_added"] or data["args_removed"] or data["sig_args_added"] or data["sig_args_removed"] else ""
            res = "✔" if data["result_fields_added"] or data["result_fields_removed"] else ""
            dep = "✔" if data["newly_deprecated"] else ""

            # High-level types of changes (for Notes column)
            change_types = ", ".join(data["reasons"])  # e.g. "signature, arguments"

            # Anchor link to detailed section (GitHub-style heading id)
            link = f"[`{key}`](#{key.replace(' ', '-').lower()})"
            report.append(f"| {link} | {sig} | {args} | {res} | {dep} | {change_types} |")

        report.append("")  # table spacing

    # ----- One appearance per RPC via priority bucketing -----
    priority = ["signature", "deprecation", "arguments", "result", "docs-only"]
    bucket = {k: [] for k in priority}
    for key, d in changes["modified"].items():
        for r in priority:
            if r in d["reasons"]:
                bucket[r].append((key, d))
                break

    # Signature
    if bucket["signature"]:
        report.append(f"### RPCs with Signature Changes ({len(bucket['signature'])})\n")
        report.append("*These commands changed their top-line call format*\n")
        for key, d in bucket["signature"]:
            render_change_details(key, d, report)

    # Deprecations
    if bucket["deprecation"]:
        report.append(f"### New Deprecation Notices ({len(bucket['deprecation'])})\n")
        for key, d in bucket["deprecation"]:
            render_change_details(key, d, report)

    # Arguments
    if bucket["arguments"]:
        report.append(f"### Argument Changes ({len(bucket['arguments'])})\n")
        for key, d in bucket["arguments"]:
            render_change_details(key, d, report)

    # Result fields
    if bucket["result"]:
        report.append(f"### Result Field Changes ({len(bucket['result'])})\n")
        for key, d in bucket["result"]:
            render_change_details(key, d, report)

    # Docs-only
    if bucket["docs-only"]:
        report.append(f"### Other Modified RPCs (Docs-only, {len(bucket['docs-only'])})\n")
        report.append("*Changed descriptions/examples without structural differences*\n")
        for key, d in bucket["docs-only"]:
            render_change_details(key, d, report)

    # Key observations (example heuristics; adapt to your needs)
    report.append("## Key Observations\n")

    # Rebuild sig_changes & newly_depr context from buckets for observations
    sig_changes = bucket["signature"]
    newly_depr = dict(bucket["deprecation"])

    evo_related = [ k for k, v in sig_changes if "evo" in v["new_sig"].lower() or "platform" in v["new_sig"].lower() ]
    if evo_related:
        report.append(f"### Platform/EvoNode Signatures ({len(evo_related)})")
        for key in evo_related:
            report.append(f"- `{key}`")
        report.append("")

    service_depr = [
        k for k, v in newly_depr.items()
        if any("service" in s.lower() for s in v["newly_deprecated"])
    ]
    if service_depr:
        report.append("### Deprecated 'service' Field\n")
        report.append("These commands now deprecate the `service` field in favor of structured `addresses`:\n")
        for k in service_depr:
            report.append(f"- `{k}`")
        report.append("")

    return "\n".join(report), old_version, new_version

# ---------- CLI ----------

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description="Generate executive summary of Dash Core RPC changes between two JSONL dumps."
    )
    parser.add_argument("old_jsonl", help="Path to OLD version JSONL file")
    parser.add_argument("new_jsonl", help="Path to NEW version JSONL file")
    args = parser.parse_args()

    report, old_ver, new_ver = generate_summary(args.old_jsonl, args.new_jsonl)

    # Build output filename from metadata versions if available
    safe_old = re.sub(r'[^A-Za-z0-9._-]+', '_', old_ver)
    safe_new = re.sub(r'[^A-Za-z0-9._-]+', '_', new_ver)
    output_file = f'rpc-changes-summary-{safe_old}-to-{safe_new}.md'

    with open(output_file, 'w') as f:
        f.write(report)

    print(f"\n\nSummary generated: {output_file}")
    print("\n" + "="*80)
    print(report)
