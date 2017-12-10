#!/bin/bash

# Specify the number of simultaneous running tasks
TASKS=4

# Check the right number of arguments and print usage elsewise
if [ "$#" -ne 2 ]; then
    echo "Usage: golem3d.sh INPUT_DIRECTORY OUTPUT_DIRECTORY"
    exit 1
fi

# Check if dependency is installed
if ! command -v stereo-conv &> /dev/null; then
    echo "Stereo Photo Viewer (https://stereophotoview.bitbucket.io/en/) is missing on your computer. Please install it before running this script."
    exit 1
fi

# Execute the commands in parallel
IFS=$(echo -en "\n\b")
for filename in $1/*.MPO; do
    ((i=i%TASKS)); ((i++==0)) && wait
    stereo-conv "$filename" -o "$2/$(basename "$filename" .MPO).jpg" --operations auto-align:vh --output-layout AnaglyphRC --input-layout Separate &
done
