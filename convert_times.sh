#! /bin/bash
# Given a text file from extract_*.sh convert the times to
# morning, afternoon, evening
set -e

cat $1 | cut -f 2 -d ',' | while read FIELD; do
    TIME=$(echo $FIELD | sed 's/[0-9]*-[0-9]* \([0-9]*\).*/\1/g');
    if [[ "$TIME" != "$FIELD" ]]; then
        if [[ $TIME -lt 12 && $TIME -gt 2 ]]; then
            TIME="MORNING"
        elif [[ $TIME -ge 12 && $TIME -lt 17 ]]; then
            TIME="AFTERNOON"
        else
            TIME="EVENING"
        fi
    else
        TIME="time_of_day"
    fi
    echo $TIME
done | paste -d ',' $1 - > $2
