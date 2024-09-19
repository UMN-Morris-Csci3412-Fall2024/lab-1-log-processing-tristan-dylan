#!/bin/bash

#Creates a temporary scratch directory
here=`pwd`
scratch=$(mktemp -d)
echo "Created scratch directory: $scratch"

for file in "$@"; do
    machineName=$(basename "$file" _secure.tgz)
    machineNameDir="$scratch/$machineName"
    echo "Processing $machineName"
    mkdir -p "$machineNameDir"
    echo "Created directory: $machineNameDir"
    tar -xzf "$file" -C "$machineNameDir"
    echo "Unzipped $file to $machineNameDir"
    ./bin/process_client_logs.sh "$machineNameDir"
done
echo  $(pwd)
echo "Processing logs complete"

#Calls create_username_dist.sh, create_hours_dist.sh, and create_country_dist.sh on the scratch directory
./bin/create_username_dist.sh "$scratch"
echo "Created username distribution"
./bin/create_hours_dist.sh "$scratch"
echo "Created hours distribution"
./bin/create_country_dist.sh "$scratch"
echo "Created country distribution"

#Assembles the report
./bin/assemble_report.sh "$scratch"
echo "Assembled report"

#Moves the report to the current directory
mv "$scratch"/failed_login_summary.html "${here}"
echo "Moved report to ${here}"

#Removes the scratch directory
rm -r "$scratch"
echo "Removed scratch directory: $scratch"
