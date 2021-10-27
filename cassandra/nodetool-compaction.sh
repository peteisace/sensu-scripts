#!/bin/bash

maximum=$1

# get value of compaction
compaction=`nodetool compactionstats`

# get the number
compaction_stats=`echo $compaction | sed -e "s/pending tasks\: //"`

echo "${compaction}"

# evaluate the number.
if test $compaction_stats -gt $maximum;
then
    exit 2
else
    exit 0
fi