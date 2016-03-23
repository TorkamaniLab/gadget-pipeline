#! /bin/bash 
# Formats medication information after it's been cleaned.
#
# Usage: ./<script> <input>
INPUT=$1

cat $INPUT | cut -d ',' -f 1,2 | sed '1d' | sed 's/\([a-zA-Z ]\)=.*/\1/g'  
