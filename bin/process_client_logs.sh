#!/bin/bash

# Move to the specified directory
cd $1

#awk '/Failed password for invalid user/ {print $1, $2, $3, $11, $13}' var/log/* > failed_login_data.txt
cat var/log/* | awk '/Failed password for invalid user/ {
    split($3, time, ":");
    print $1, $2, time[1], $11, $13
}
/Failed password for / && !/invalid user/ {
    split($3, time, ":");
    print $1, $2, time[1], $9, $11
}' > failed_login_data.txt