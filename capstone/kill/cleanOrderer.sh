#!/bin/bash

pkill -9 python3

pids=`ps ax | grep -i 'orderer' | grep -v grep | awk '{print $1}'`
echo "Printing PIDS"
echo $pids
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


rm -rf $HOME/orderer