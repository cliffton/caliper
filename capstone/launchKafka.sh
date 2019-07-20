#!/bin/bash

export CALIPER_FABRIC=$HOME/caliper/packages/caliper-samples/network/fabric-v1.4/kafka/


# set -x

function usage {
    echo "./launchZookeeper.sh CONFIG_FILE"
}

# Check if ORG_NAME passed
# if [ -z $1 ];
# then
#     usage
#     echo "Please provide the CONFIG_FILE!!!"
#     exit 0
# else
#     CONFIG_FILE=$1
# fi


pids=`ps ax | grep -i 'kafka' | grep -v grep | awk '{print $1}'`
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

cd $HOME/kafka
bin/kafka-server-start.sh -daemon config/server.properties &