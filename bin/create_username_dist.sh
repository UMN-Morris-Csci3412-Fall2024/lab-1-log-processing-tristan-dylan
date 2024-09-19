#!/bin/bash

# Move to the specified directory
cd $1

# Temporary file to store all usernames
temp_file=$(mktemp)

# Iterate over each sub-directory
for dir in */; do
    if [ -f "${dir}failed_login_data.txt" ]; then
        awk '{print $4}' "${dir}failed_login_data.txt" >> "$temp_file"
    fi
done

# Sort and count occurrences of each username
sort "$temp_file" | uniq -c | awk '{
    printf "data.addRow([\x27%s\x27, %d]);\n", $2, $1
}' >> username_dist_data.txt


# Wrap the data section with header and footer
../bin/wrap_contents.sh username_dist_data.txt ../html_components/username_dist username_dist.html

# Clean up temporary file
rm "$temp_file" username_dist_data.txt