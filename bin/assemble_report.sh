#!/bin/bash

# Move to specified directory
here=`pwd`
cd $1

# Collects required files
COUNTRY_DIST="country_dist.html"
HOURS_DIST="hours_dist.html"
USERNAME_DIST="username_dist.html"
temp_combined="temp_combined.html"

# cat the contents of the three files into a temporary file
cat $COUNTRY_DIST $HOURS_DIST $USERNAME_DIST > "$temp_combined"

cd "${here}"

# Wrap the contents of the temporary file with the header and footer
./bin/wrap_contents.sh "${1}/$temp_combined" ./html_components/summary_plots "${1}/failed_login_summary.html"

# Remove the temporary file
rm "${1}/$temp_combined"