#!/usr/bin/env bash
set -euo pipefail

INDEX="index.md"
OUTPUT="expression.md"

# Truncate output file
: > "$OUTPUT"

# 1. Add index.md first
echo "## index.md" >> "$OUTPUT"
cat "$INDEX" >> "$OUTPUT"
printf "\n\n" >> "$OUTPUT"

# 2. Append each linked file in index.md order
grep -oE '\([^)]+\.md\)' "$INDEX" | tr -d '()' | while IFS= read -r rf; do
  # Skip index.md if linked inside itself
  if [ "$rf" = "index.md" ]; then
    continue
  fi
  if [ -f "$rf" ]; then
    echo "## $rf" >> "$OUTPUT"
    cat "$rf" >> "$OUTPUT"
    printf "\n\n" >> "$OUTPUT"
  else
    echo "WARNING: $rf referenced in $INDEX but not found locally." >&2
  fi
done

# 3. Append scaffold_overflow.md at the very end
if [ -f "scaffold_overflow.md" ]; then
  echo "## scaffold_overflow.md" >> "$OUTPUT"
  cat "scaffold_overflow.md" >> "$OUTPUT"
  printf "\n\n" >> "$OUTPUT"
else
  echo "WARNING: scaffold_overflow.md not found, skipping." >&2
fi

echo "Created $OUTPUT"