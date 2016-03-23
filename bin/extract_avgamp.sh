#! /bin/bash
set -e
# Extracts the relevant average amplitude information from the raw analysis files.
# Usage: sh <script> <files to extract from>

echo "sample,time,3.125-6.25Hz,6.25-12.5Hz"
for file in $@; do
    file_num=`echo $file | sed 's/.*data.cut.\([0-9]*\).analyzed.csv/\1/g'`
    echo "$file_num" > temp
    sed '1d' $file | cut -f 1,15,18 -d ',' | paste -d ',' temp -
done | sed '/^,/d'| sort -n
rm temp


