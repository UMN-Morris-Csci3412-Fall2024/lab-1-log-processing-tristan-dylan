#!/bin/bash

#Creates a temporary scratch directory
scratch=$(mktemp -d)
echo "Created scratch directory: $scratch"

for file in "$1"/*.tgz; do
    machineName=$(basename "$file" _secure.tgz)
    machineNameDir="$scratch/$machineName"
    mkdir -p "$machineNameDir"
    tar -xzf "$file" -C "$machineNameDir"
    bin/process_client_logs.sh "$machineNameDir"
done

#Calls create_username_dist.sh, create_hours_dist.sh, and create_country_dist.sh on the scratch directory
bin/create_username_dist.sh "$scratch"
bin/create_hours_dist.sh "$scratch"
bin/create_country_dist.sh "$scratch"

#Assembles the report
bin/assemble_report.sh "$scratch"

#Moves the report to the current directory
mv "$scratch"/failed_login_summary.html "$2"

#Removes the scratch directory
rm -r "$scratch"
