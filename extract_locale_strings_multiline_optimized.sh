#!/bin/bash

# Create a temporary file to store unique localized strings
temp_file=$(mktemp)

# Find all Dart files in the current directory and its subdirectories
find . -type f -name "*.dart" -exec cat {} \; | while IFS= read -r line; do
  # Remove leading and trailing white spaces (including tabs and other whitespace characters)
  line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # Append the cleaned line to the cleaned_file
  cleaned_file+="$line"
done

# Remove double single quotes (''), double double-quotes ("") or a combination of both
cleaned_file=$(echo "$cleaned_file" | sed "s/''//g; s/\"\"//g; s/'\"/\"''/g")


# Create a new temporary file to store the localized strings
localized_temp_file=$(mktemp)

# Use grep with a regular expression to find and extract localized strings
grep -oE "'([^']+)'\.localized|\"([^\"]+)\"\.localized" <<< "$cleaned_file" | \
  sed -E 's/'"'"'([^'"'"']+)'"'"'\.localized|"([^"]+)"\.localized/\1\2/' | \
  sed -E '/^\s*$/d' | \
  sort -u > "$localized_temp_file"

# Create a new temporary file to store the formatted JSON
formatted_temp_file=$(mktemp)

# Generate unescaped JSON content
{
  echo "{"
  while IFS= read -r line; do
    line_without_quotes=$(echo "$line" | sed 's/^\(["'\'']\)\(.*\)\1$/\2/')
    echo "\"$line_without_quotes\":\"$line_without_quotes\","
  done < "$localized_temp_file"
  echo "}"
} >> "$formatted_temp_file"

# Define the output JSON file name
output_file="localized_strings.json"

# Rename the unescaped JSON file
mv "$formatted_temp_file" "$output_file"

# Clean up the temporary files
rm "$temp_file" "$localized_temp_file"

echo "Localized strings extracted and saved to $output_file"
