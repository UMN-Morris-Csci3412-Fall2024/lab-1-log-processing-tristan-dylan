# #!/bin/bash


# # Move to specified directory
# cd $1


# inputfile="$1"


# # Initialize the output file
# # cp ../html_components/country_dist_header.html country_dist.html


# # # Extract IP adresses
# # find . -name 'failed_login_data.txt' -exec awk '{print $5}' {} + > all_ips.txt


# # # Sort the IP adresses
# # sort all_ips.txt -o all_ips_sorted.txt


# # Temporary file to store all times
# tempfile=$(mktemp)


# # Iterate over each sub-directory
# for dir in */; do
#     if [ -f "${dir}failed_login_data.txt" ]; then
#         awk '{print $5}' "${dir}failed_login_data.txt" >> "$tempfile"
#     fi
# done


# #Sorted Ips
# sortedtempfile=$(mktemp)
# sort "$tempfile" > $sortedtempfile


# # Join Ips and Map
# joinedtempfile=$(mktemp)
# join "$sortedtempfile" <(sort etc/country_IP_map.txt) > "$joinedtempfile"


# # Extract country codes and count occurrences
# awk '{print $2}' "$joinedtempfile" | sort | uniq -c > "$countrytempfile"


# awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' "$countrytempfile" > "$tempfile"


# ../bin/wrap_contents.sh "$tempfile" "country_dist" "$inputfile" "/country_dist.html"


# # Clean up directory
# rn "$tempfile" "$sortedtempfile" "$joinedtempfile" "$countrytempfile"








# # # Wrap the data  section with header and footer
# # ../bin/wrap_contents.sh country_data.txt ../html_components/country_dist_header.html ../html_components/country_dist_footer.html > country_dist.html


# # # # Clean up temporary files
# # # rm all_ips.txt all_ips_sorted.txt country_IP_map_sorted.txt ip_country_map.txt country_data.txt


# # # Clean up temporary files
# # rm all_ips.txt all_ips_sorted.txt country_IP_map_sorted.txt ip_country_map.txt country_data.txt







#!/bin/bash

# Move to specified directory
cd "$1"

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

# Join IP addresses with country map
joinedtempfile=$(mktemp)
join -1 1 -2 1 "$sortedtempfile" <(sort ../etc/country_IP_map.txt) > "$joinedtempfile"

# Extract country codes and count occurrences
countrytempfile=$(mktemp)
awk '{print $2}' "$joinedtempfile" | sort | uniq -c > "$countrytempfile"

# Format the data for the Geo Chart
awk '{print "data.addRow([\x27" $2 "\x27, " $1 "]);"}' "$countrytempfile" > "$tempfile"

# Wrap the data section with header and footer
../bin/wrap_contents.sh "$tempfile" ../html_components/country_dist_header.html ../html_components/country_dist_footer.html > country_dist.html

# Clean up temporary files
rm "$tempfile" "$sortedtempfile" "$joinedtempfile" "$countrytempfile"