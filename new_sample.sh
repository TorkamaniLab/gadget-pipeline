#! /bin/bash
# Makes a new sample folder, sub-folders, and fetches their data.
#
# Usage: ./new_sample.sh <sample id>

SAMPLE=$1
RAW_REQ="~/Dropbox/Scripps/projects/pd_predict/api/sample/raw_req.sh"

mkdir $SAMPLE $SAMPLE/breakdown $SAMPLE/analysis

PEBBLE_DATA=$(sh $RAW_REQ $SAMPLE 'Pebble Accelerometer')
MEDS_DATA=$(sh $RAW_REQ $SAMPLE 'Took Medication')
ANSWER_DATA=$(sh $RAW_REQ $SAMPLE 'Trial Answers')

echo $PEBBLE_DATA | zcat > $SAMPLE/pebble.raw.csv
echo $MEDS_DATA | zcat > $SAMPLE/medication.raw.csv
echo $ANSWER_DATA | zcat > $SAMPLE/answers.raw.csv

sh fix_intel_data $SAMPLE/pebble.raw.csv $SAMPLE/pebble.cleaned.csv
python $CUTTER

