#!/bin/bash

# Move to specified directory
cd "$1"
echo "Moved to $(pwd)"

# Temporary file to store all IP addresses
tempfile=$(mktemp)

# Iterate over each sub-directory and extract IP addresses
for dir in */; do
    if [ -f "${dir}failed_login_data.txt" ]; then
        awk '{print $5}' "${dir}failed_login_data.txt" >> "$tempfile"
    fi
done

# Sort the extracted IP addresses
sortedtempfile=$(mktemp)
sort "$tempfile" > "$sortedtempfile"
echo "sorted and extracted IP adresses"

# Join IP addresses with country map
joinedtempfile=$(mktemp)
join -1 1 -2 1 "$sortedtempfile" <(sort ../etc/country_IP_map.txt) > "$joinedtempfile"
echo "joined IP addresses with country_IP_map"

# Extract country codes and count occurrences
countrytempfile=$(mktemp)
awk '{print $2}' "$joinedtempfile" | sort | uniq -c > "$countrytempfile"
echo "extracted country codes and counted occurences"

# Format the data for the Geo Chart
awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' "$countrytempfile" > "$tempfile"
echo "printed:" $tempfile

# Wrap the data section with header and footer
../bin/wrap_contents.sh "$tempfile" ../html_components/country_dist country_dist.html
# Clean up temporary files
rm "$tempfile" "$sortedtempfile" "$joinedtempfile" "$countrytempfile"
