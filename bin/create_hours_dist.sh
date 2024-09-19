#!/bin/bash

# Move to the specified directory
cd $1

# Temporary file to store all times
temp_file=$(mktemp)

# Iterate over each sub-directory
for dir in */; do
    if [ -f "${dir}failed_login_data.txt" ]; then
        awk '{print $3}' "${dir}failed_login_data.txt" >> "$temp_file"
    fi
done

# Sort and count occurrences of each username
sort "$temp_file" | uniq -c | awk '{
    printf "data.addRow([\x27%s\x27, %d]);\n", $2, $1
}' >> hours_dist_data.txt

# Wrap the data section with header and footer
../bin/wrap_contents.sh hours_dist_data.txt ../html_components/hours_dist hours_dist.html

# Clean up temporary file
rm "$temp_file" hours_dist_data.txt
