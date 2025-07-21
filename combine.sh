#!/usr/bin/env bash
set -euo pipefail

README="README.md"
OUTPUT="awakening.md"

# Truncate output
: > "$OUTPUT"

# 1. Add README.md first
echo "## README.md" >> "$OUTPUT"
cat "$README" >> "$OUTPUT"
printf "\n\n" >> "$OUTPUT"

# 2. Append each linked file in README order
grep -oE '\([^)]+\.md\)' "$README" | tr -d '()' | while IFS= read -r rf; do
  if [ -f "$rf" ]; then
    echo "## $rf" >> "$OUTPUT"
    cat "$rf" >> "$OUTPUT"
    printf "\n\n" >> "$OUTPUT"
  else
    echo "WARNING: $rf referenced in $README but not found locally." >&2
  fi
done

# 3. Append supported-stirring.md at the very end
if [ -f "supported-stirring.md" ]; then
  echo "## supported-stirring.md" >> "$OUTPUT"
  cat "supported-stirring.md" >> "$OUTPUT"
  printf "\n\n" >> "$OUTPUT"
else
  echo "WARNING: supported-stirring.md not found, skipping." >&2
fi

echo "Created $OUTPUT"