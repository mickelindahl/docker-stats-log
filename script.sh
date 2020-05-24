#!/bin/bash

CONTAINERS=$(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc) | cut -c2-)

WEEK=$(date '+%W')
MONTH=$(date '+%m')
THE_DATE=$(date '+%Y-%m-%d %H:%M:%S')

for CONTAINER in $CONTAINERS; do

   MEM=$(docker stats --no-stream $CONTAINER --format '{{ .MemUsage }}')
   CPU=$(docker stats --no-stream $CONTAINER --format '{{.CPUPerc}}')

   #echo "data/"$CONTAINER"-week-"$WEEK-"mem"

   echo "$THE_DATE $MEM" >> "data/"$CONTAINER"_week_"$WEEK".mem"
   # echo "$THE_DATE $MEM" >> "data/"$CONTAINER"_month_"$MONTH".mem"
   echo "$THE_DATE $CPU" >> "data/"$CONTAINER"_week_"$WEEK".cpu"
   # echo "$THE_DATE $CPU" >> "data/"$CONTAINER"_month_"$MONTH".cpu"

done
