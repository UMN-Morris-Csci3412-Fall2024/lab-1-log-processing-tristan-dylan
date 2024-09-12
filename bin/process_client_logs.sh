#!/bin/bash

# Move to the specified directory
cd $1

#awk '/Failed password for invalid user/ {print $1, $2, $3, $11, $13}' var/log/* > failed_login_data.txt
