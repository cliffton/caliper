#!/bin/bash

pids=`ps ax | grep -i 'peer' | grep -v grep | awk '{print $1}'`
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


rm -rf $HOME/peer