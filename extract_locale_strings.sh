#!/bin/bash

# Create a temporary file to store unique localized strings
temp_file=$(mktemp)

# Find all Dart files in the current directory and its subdirectories
dart_files=$(find . -type f -name "*.dart")

# Iterate through Dart files
for file in $dart_files; do
  # Use grep with a regular expression to find and extract localized strings
  localized_strings=$(grep -oE "'([^']+)'\.localized|\"([^\"]+)\"\.localized" "$file")

  # Iterate through the extracted strings
  while read -r line; do
    # Remove the trailing ".localized" and escape special characters
    line=$(echo "$line" | sed 's/\.localized//g' | sed 's/"/\\"/g')

    # Append the string to the temporary file if it's not empty
    if [ -n "$line" ]; then
      # Remove single quotes before appending to the file
      line_without_quotes=$(echo "$line" | sed "s/'//g")
      echo "$line_without_quotes" >> "$temp_file"
    fi
  done <<< "$localized_strings"
done

# Sort the temporary file and remove duplicates
sort -u "$temp_file" -o "$temp_file"

# Create a new temporary file to store the formatted JSON
formatted_temp_file=$(mktemp)

# Convert the sorted file to a JSON object with newlines and no single quotes
echo "{" >> "$formatted_temp_file"
while IFS= read -r line; do
  echo "\"$line\":\"$line\"," >> "$formatted_temp_file"
done < "$temp_file"
# Remove the trailing comma
sed -i '$ s/,$//' "$formatted_temp_file"
echo "}" >> "$formatted_temp_file"

# Define the output JSON file name
output_file="localized_strings.json"

# Save the formatted JSON object to the output file
mv "$formatted_temp_file" "$output_file"

# Clean up the temporary files
rm "$temp_file"

echo "Localized strings extracted and saved to $output_file"
