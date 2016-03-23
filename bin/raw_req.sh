#! /bin/bash
# Sample export from Intel's FoxData Application.
# Usage: ./<script> <sample_id> <data_type>


BEGIN_DATE="2016-01-01 00:00"
END_DATE=$(date +"%Y-%m-%d %H:%M")
SAMPLE=$1
DATA_TYPE=$2

DATA='{
        "credentials": {
            "user": "scrippsOwner",
            "pass": "123456"
        },
        "trial": "scripps",
        "user": "'$SAMPLE'",
        "measurement": "'$DATA_TYPE'",
        "time_zone": 0,
        "start": "'$BEGIN_DATE'",
        "end": "'$END_DATE'"
    }';
curl -H "Content-Type: application/json" \
    --data "$DATA" http://export.foxdata.org/api/v1/export 
