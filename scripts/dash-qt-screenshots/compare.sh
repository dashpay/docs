#!/bin/bash
# Compare images captured by capture.sh with the committed ones.
#
# Usage: compare.sh [--install] [other-out-dir]
#   (default)      compare $WORK/out with the repository
#   other-out-dir  compare $WORK/out with another capture (e.g. a second run)
#   --install      copy every image that differs into the repository
#
# Only images written by the latest capture.sh run are compared, and only
# regular PNG files under docs/user/. Prints one line per image: changed pixels
# (%), or "same" / "size a -> b" / "new". --install copies after listing them all.
set -euo pipefail
. "$(dirname "$0")/lib.sh"

REPO=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
OUT=$WORK/out
INSTALL=0; BASE=$REPO
for a in "$@"; do case $a in --install) INSTALL=1 ;; *) BASE=$a ;; esac; done
[ -f "$OUT/.run-start" ] || die "no captures in $OUT; run capture.sh first"
check_work
[ $INSTALL = 0 ] || [ "$BASE" = "$REPO" ] || die "--install only works against the repository"

changed=0; COPY=()
while IFS= read -r f; do
  rel=${f#"$OUT"/}; old=$BASE/$rel
  if [ "$(identify -format %m "$f" 2>/dev/null)" != PNG ]; then status="error: not a PNG"
  elif [ ! -f "$old" ]; then status=new
  else
    a=$(identify -format '%wx%h' "$old"); b=$(identify -format '%wx%h' "$f")
    if [ "$a" != "$b" ]; then status="size $a -> $b"
    else
      rc=0; px=$(compare -metric AE "$old" "$f" null: 2>&1) || rc=$?; px=${px%% *}
      if [ $rc -gt 1 ]; then status="error: compare failed"
      elif [ "$px" = 0 ]; then status=same
      else status=$(awk -v p="$px" -v s="$b" 'BEGIN{split(s,d,"x"); printf "%.2f%% of pixels differ", 100*p/(d[1]*d[2])}')
      fi
    fi
  fi
  printf '%-28s %s\n' "$status" "$rel"
  if [ "$status" != same ] && [ "${status#error}" = "$status" ]; then
    changed=$((changed+1)); COPY+=("$rel")
  fi
done < <(find "$OUT/docs/user" -type f -name '*.png' -newer "$OUT/.run-start" | sort)
if [ $INSTALL = 1 ]; then   # normal repository permissions, not WORK's private ones
  (umask 022; for rel in "${COPY[@]}"; do install -D -m 644 -- "$OUT/$rel" "$BASE/$rel"; done)
fi
echo "$changed image(s) differ$([ $INSTALL = 1 ] && echo ', copied into the repository' || true)"
