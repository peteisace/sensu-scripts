#!/bin/bash

since_seconds=$1
min_found=${2:-0}

# get the date in milliseconds
current_date=`date +%s%3N`

# now subtract
since_ms=$(($since_seconds*1000))
current_date=$(($current_date-$since_ms))

# now execute our query
cqlout=`cqlsh -e "SELECT COUNT(*) FROM ts.metrics WHERE time >= minTimeUuid(${current_date}) ALLOW FILTERING" | tail -n 11`
echo "${cqlout}"

count=`echo "${cqlout}" | grep -no "[0-9]\\+" | grep "4:" | sed -e "s/4://"`
num_count=$(($count))

if [ "$num_count" -gt "$min_found" ];
then
    echo "Found ${num_count} records, greater than ${min_found}"
    exit 0
else
    echo "Was looking for records greater than ${min_found} but found ${num_count}"
    exit 2
fi
