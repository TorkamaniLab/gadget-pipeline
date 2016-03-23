#! /bin/bash
# Converts Intel's Export data format to a format usable by my freq analysis.
# use ./fix_intel_data.sh <intel_data_file> <output file>
set -e


cut -f 3,5-7 -d ',' $1 |
    sed 's/[xyz]=//g' |
    sed 's/[{}]//g' > .temp

cut -f 1 -d ',' .temp | while read DATE; do
        echo $(date -d "$DATE" +"%s%N")
    done |
    sed 's/000000\b//g' |
    paste - .temp -d ',' |
    cut -f 1,3- -d ',' > $2
rm .temp
