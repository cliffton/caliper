#!/bin/bash

pids=`ps ax | grep -i 'zookeeper' | grep -v grep | awk '{print $1}'`
echo "Printing PIDS"
echo pids
for pid in $(eval echo $pids)
do
    if [ $pid == $$ ]
    then
        echo "Current PID = " $pid
    else
       echo "########### kill -9 $pid #############"
       kill -9 $pid
    fi
done


rm -rf /data/zookeeper/version-2