#!/bin/bash

pkill -9 python3

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

docker stop $(docker ps -aq)

docker rm $(docker ps -aq)

docker rmi $(docker images -q)

docker rm $(docker ps -a -f status=exited -q)

docker rmi $(docker images -a -q)


rm -rf $HOME/peer