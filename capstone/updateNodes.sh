#!/bin/bash

set +x


if [ -z $1 ];
then
    echo "Please provide the cmd!!!"
    exit 0
else
    START_NODE=$1
fi


if [ -z $2 ];
then
    echo  "Please specify start!!!"
    exit 0
else
    END_NODE=$2
fi


if [ -z "$3" ];
then
    echo  "Please specify cmd!!!"
    exit 0
else
    MY_CMD=$3
fi

for ip in $(eval echo {$START_NODE..$END_NODE})
do
	echo "########### Running $MY_CMD on 10.10.10.$ip #############"
	ssh atomicpi@10.10.10.$ip $MY_CMD  
	echo " "
done