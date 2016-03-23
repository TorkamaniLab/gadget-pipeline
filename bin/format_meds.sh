#! /bin/bash 
# Formats medication information after it's been cleaned.
#
# Usage: ./<script> <input>
INPUT=$1

cat $INPUT | cut -d ',' -f 1,2 | 
    # Remove the first line and grab the medication name
    sed '1d' | sed 's/\([a-zA-Z ]\)=.*/\1/g' | 
    # Filter everything that's not a tilt-maze entry.
    grep -iv 'maze' |
    # Optional: Only grab L-Dopa meds.
    grep -i 'dopa'
