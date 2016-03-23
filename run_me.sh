#! /bin/bash
# A simple script to invoke metapipe on a given sample.
# Usage: ./run_me.sh <sample_id> <API_USER> <API_PASS>
SAMPLE=$1
USER=$2
PASS=$3

mkdir $SAMPLE; cd $SAMPLE
cp -r ../bin .
cat ../pipeline.mp | 
    sed "s/__sample_id__/$SAMPLE/g" |
    sed "s/__api_username__/$USER/g"|
    sed "s/__api_password__/$PASS/g" > pipeline.mp

metapipe pipeline.mp | sh
