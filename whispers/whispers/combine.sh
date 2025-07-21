#!/usr/bin/env bash
set -euo pipefail

INDEX="index.md"
OUTPUT="essence.md"

# Truncate output
: > "$OUTPUT"

# 1. Add index.md
echo "## index.md" >> "$OUTPUT"
cat "$INDEX" >> "$OUTPUT"
printf "\n\n" >> "$OUTPUT"

# 2. Files linked in index.md
grep -oE '\([^)]+\.md\)' "$INDEX" | tr -d '()' | while IFS= read -r f; do
  if [[ "$f" == "$INDEX" ]]; then continue; fi
  if [[ -f "$f" ]]; then
    echo "## $f" >> "$OUTPUT"
    cat "$f" >> "$OUTPUT"
    printf "\n\n" >> "$OUTPUT"
  else
    echo "WARNING: $f referenced in $INDEX but not found." >&2
  fi
done

# 3. Add voids-gentle-hold.md explicitly at the end
if [[ -f "voids-gentle-hold.md" ]]; then
  echo "## voids-gentle-hold.md" >> "$OUTPUT"
  cat "voids-gentle-hold.md" >> "$OUTPUT"
  printf "\n\n" >> "$OUTPUT"
else
  echo "WARNING: voids-gentle-hold.md not found, skipping." >&2
fi

echo "Created $OUTPUT"