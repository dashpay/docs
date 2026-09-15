#!/usr/bin/env python3
"""Check that RPC cross-reference links point at the RPC they name.

Scans Markdown for links of the form [`<rpc name>` RPC](<path>#<anchor>) and
fails when the anchor refers to a different RPC than the link text names.

Subcommands are exempt: "mnsync reset" may link to #mnsync (the parent section)
or #mnsync-reset (its own section). The prefix comparison is word-based, so a
stale name like `signrawtransaction` -> #signrawtransactionwithkey is still
reported even though one is a string prefix of the other.

Usage: scripts/check-rpc-links.py [paths...]   (default: docs/)
"""

import re
import sys
from pathlib import Path

LINK_RE = re.compile(r"\[`([a-z0-9 ]+)` RPC\]\(([^)#]*)#([a-z0-9-]+)\)")


def anchor_matches(name: str, anchor: str) -> bool:
    """True if `anchor` plausibly refers to the RPC named `name`."""
    words = name.split()
    # Accept the full name, or any leading run of words (the parent section),
    # joined either with hyphens or with nothing.
    for i in range(len(words), 0, -1):
        prefix = words[:i]
        if anchor in ("-".join(prefix), "".join(prefix)):
            return True
    return False


def check_file(path: Path) -> list[str]:
    failures = []
    for lineno, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        for name, _target, anchor in LINK_RE.findall(line):
            if not anchor_matches(name, anchor):
                failures.append(
                    f"{path}:{lineno}: [`{name}` RPC] links to #{anchor}"
                )
    return failures


def main(argv: list[str]) -> int:
    roots = [Path(a) for a in argv[1:]] or [Path("docs")]
    files: list[Path] = []
    for root in roots:
        files.extend([root] if root.is_file() else sorted(root.rglob("*.md")))

    failures = [f for path in files for f in check_file(path)]
    if failures:
        print("Mis-aimed RPC links found:\n", file=sys.stderr)
        for failure in failures:
            print(f"  {failure}", file=sys.stderr)
        print(
            f"\n{len(failures)} problem(s). The link text names one RPC but the "
            f"anchor points at another.",
            file=sys.stderr,
        )
        return 1

    print(f"OK: checked {len(files)} file(s); all RPC links point at the RPC they name.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
