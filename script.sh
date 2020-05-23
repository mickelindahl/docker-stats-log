#!/bin/bash

CONTAINERS=$(docker inspect --format='{{.Name}}' $(docker ps -aq --no-trunc) | cut -c2-)

WEEK=$(date '+%w')
MONTH=$(date '+%m')

for CONTAINER in $CONTAINERS; do

   THE_DATE=$(date '+%Y-%m-%d %H:%M:%S')
   MEM=$(docker stats --no-stream $CONTAINER --format '{{ .MemUsage }}')
   CPU=$(docker stats --no-stream $CONTAINER --format '{{.CPUPerc}}')

   #echo "data/"$CONTAINER"-week-"$WEEK-"mem"

   echo "$THE_DATE $MEM" >> "data/"$CONTAINER"_week_"$WEEK".mem"
   echo "$THE_DATE $MEM" >> "data/"$CONTAINER"_month-"$MONTH".mem"
   echo "$THE_DATE $CPU" >> "data/"$CONTAINER"_week-"$WEEK".cpu"
   echo "$THE_DATE $CPU" >> "data/"$CONTAINER"_month-"$MONTH".cpu"

done
