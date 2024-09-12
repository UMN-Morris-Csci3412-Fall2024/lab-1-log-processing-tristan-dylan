#!/bin/bash

# Move to the specified directory
cd $1

# extract the username counts from the failed login data
awk '{print $4}' failed_login_data.txt | sort | uniq -c | awk '{print "data.addRow([\x27"$2"\x27, "$1"]);"}'
