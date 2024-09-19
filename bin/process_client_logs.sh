#!/bin/bash

# Move to the specified directory
cd "$1" || exit

# extract the needed data from the log files
cat var/log/* | awk '/Failed password for invalid user/ {
    split($3, time, ":");
    print $1, $2, time[1], $11, $13
}
/Failed password for / && !/invalid user/ {
    split($3, time, ":");
    print $1, $2, time[1], $9, $11
}' > failed_login_data.txt