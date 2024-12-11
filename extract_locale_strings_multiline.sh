#!/bin/bash

# Create a temporary file to store unique localized strings
temp_file=$(mktemp)

# Create a new temporary file to store the formatted JSON
formatted_temp_file=$(mktemp)

# Find all Dart files in the current directory and its subdirectories
dart_files=$(find . -type f -name "*.dart")

# Join all lines that don't end with .localized
for file in $dart_files; do
  # Read the file line by line
  while IFS= read -r line; do
    # Remove leading and trailing white spaces (including tabs and other whitespace characters)
    line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Append the cleaned line to the cleaned_file
    cleaned_file+="$line"
  done < "$file"

  # Remove double single quotes (''), double double-quotes ("") or a combination of both
  cleaned_file=$(echo "$cleaned_file" | sed "s/''//g; s/\"\"//g; s/'\"/\"''/g")

  echo "$cleaned_file" >> "$formatted_temp_file" 

  # Use grep with a regular expression to find and extract localized strings
  localized_strings=$(grep -oE "'([^']+)'\.localized|\"([^\"]+)\"\.localized" <<< "$cleaned_file")
  
  # echo "$cleaned_file"
  # echo "$localized_strings"

  # Iterate through the extracted strings
  while read -r line; do
    # Remove the trailing ".localized"
    line=$(echo "$line" | sed -E 's/\.localized//g')

    # Append the string to the temporary file if it's not empty
    if [ -n "$line" ]; then
      # Remove any double quotes within the string
      line_without_quotes=$(echo "$line" | sed 's/^\(["'\'']\)\(.*\)\1$/\2/')
      echo "\"$line_without_quotes\":\"$line_without_quotes\"," >> "$temp_file"
    fi
  done <<< "$localized_strings"
done

# Sort the temporary file and remove duplicates
sort -u "$temp_file" -o "$temp_file"

# Create a new temporary file to store the formatted JSON without escaping double quotes
unescaped_temp_file=$(mktemp)

# Generate unescaped JSON content
{
  echo "{"
  while IFS= read -r line; do
    echo "$line"
  done < "$temp_file"
  echo "}"
} >> "$unescaped_temp_file"

# Define the output JSON file name
output_file="localized_strings.json"

# Rename the unescaped JSON file
mv "$unescaped_temp_file" "$output_file"

# Clean up the temporary files
rm "$temp_file" "$formatted_temp_file"

echo "Localized strings extracted and saved to $output_file"
