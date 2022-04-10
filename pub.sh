#!/bin/sh

process() {
  # Set output filename
  output="${1%.*}".html

  # Convert markdown to html and save
  curl \
    -sS \
    -u "${GITHUB_USERNAME}:${GITHUB_TOKEN}" \
    -X POST \
    -H "Content-Type: text/plain" -H "Accept: application/vnd.github.v3+json" \
    https://api.github.com/markdown/raw \
    --data "$(cat $1)" > $output

  # Apply layout and save
  html=$(awk 'NR==FNR { a[n++]=$0; next } /{{ content }}/ { for (i=0;i<n;++i) print a[i]; next } 1' $output layout.html)
  printf "%s" "$html" > "$output"

  # Output
  echo "Processed ${output}"
}

# For each markdown file in current folder, process in parallel
for file in *.md; do process "$file" & done
wait
