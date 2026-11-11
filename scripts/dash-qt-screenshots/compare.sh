#!/bin/bash
# Compare images captured by capture.sh with the committed ones.
#
# Usage: compare.sh [--install] [other-out-dir]
#   (default)      compare $WORK/out with the repository
#   other-out-dir  compare $WORK/out with another capture (e.g. a second run)
#   --install      copy every image that differs into the repository
#
# Only images written by the latest capture.sh run are compared. Prints one line
# per image: changed pixels (%), or "same" / "size a -> b" / "new".
set -euo pipefail
. "$(dirname "$0")/lib.sh"

REPO=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
OUT=$WORK/out
INSTALL=0; BASE=$REPO
for a in "$@"; do case $a in --install) INSTALL=1 ;; *) BASE=$a ;; esac; done
[ -f "$OUT/.run-start" ] || die "no captures in $OUT; run capture.sh first"
[ $INSTALL = 0 ] || [ "$BASE" = "$REPO" ] || die "--install only works against the repository"

changed=0
while IFS= read -r f; do
  rel=${f#"$OUT"/}; old=$BASE/$rel
  if [ ! -f "$old" ]; then status=new
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
    changed=$((changed+1))
    [ $INSTALL = 1 ] && mkdir -p "$(dirname "$old")" && cp "$f" "$old"
  fi
done < <(find "$OUT" -name '*.png' -newer "$OUT/.run-start" | sort)
echo "$changed image(s) differ$([ $INSTALL = 1 ] && echo ', copied into the repository' || true)"
