#!/usr/bin/env bash

#starttime=$(date +%s)
#curr_time=$(date +%s)
#echo "date,time,memory,disk space,cpu utilization"
#while [ $curr_time -le $((starttime+5)) ]
#do
cpu=$(top -bn1 | grep load | awk '{printf "%.2f%%\n", $(NF-2)}')
dspace=$(df -h | awk '$NF=="/"{printf "%s", $5}')
mem=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
echo $(date +%m"-"%d"-"%y)",$(date +%T),$mem,$dspace,$cpu"
#sleep 1
#curr_time=$(date +%s)
#done
