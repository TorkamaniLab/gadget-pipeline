#! /bin/bash 
# Given a medications list and a list of game times, append the last time 
# meds were taken to the last game time.
# Usage: ./<script> <meds> <game>
MEDS=$1
GAME=$2

# Reverse the sorting
SORTED_MEDS=$(cat $MEDS | grep [0-9] | sort -rn)

echo "sample,time,3.125-6.25Hz,6.25-12.5Hz,time_of_day,time_since_med"

cat $GAME | while read LINE; do
    GAME_DAY_TIME=$(echo "$LINE" | cut -d ',' -f 2)
    NEW_GAME_DAY_TIME="2016-"$GAME_DAY_TIME
    # Parsing the date requires some finiky business
    if [[ $GAME_DAY_TIME == "2016-" ]]; then
        continue
    fi
    UNIXTIME=$(python - <<END
import time, calendar
try:
    t = time.strptime("$NEW_GAME_DAY_TIME", "%Y-%m-%d %H:%M")
    print(int(calendar.timegm(t))*1000)
except: pass
END
) 
    echo "$UNIXTIME $GAME_DAY_TIME"
done | sort | while read GAMETIME GAME_DAY GAME_TIME; do
    # Play the price is right
    for LINE in $SORTED_MEDS; do
        MEDS_TIME=$(echo $LINE | cut -d ',' -f 1)
        if [[ $GAMETIME -gt $MEDS_TIME ]]; then 
            TIMEDIFF=$(echo "( $GAMETIME - $MEDS_TIME ) / 1000 / 3600" | bc -l)
            TIMEDIFF=$(printf "%.0f\n" "$TIMEDIFF")
            # Only echo back if meds are less than a day old.
            if [[ TIMEDIFF -lt 25 ]]; then          
                echo "$GAME_DAY $GAME_TIME $TIMEDIFF" 
                break  
            fi
        fi
    done;
done | while read GAME_DAY GAME_TIME TIMEDIFF; do 
    # Put it all back together
    GAME_DAY_TIME=$(echo "$GAME_DAY $GAME_TIME")
    cat $GAME | while read LINE; do
        GDT=$(echo "$LINE" | cut -d ',' -f 2)
        if [[ $GDT == $GAME_DAY_TIME ]]; then
            echo "$LINE,$TIMEDIFF"
            break
        fi
    done
done;



