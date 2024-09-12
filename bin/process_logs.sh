#!/bin/bash
#Creates a temporary scratch directory
scratch=$(mktemp -d)
echo "Created scratch directory: $scratch"

#Unzips all the files in the given directory and puts them in the scratch directory
tar -xz < $1 > $scratch

