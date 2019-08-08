#!/bin/bash


function usage {
    echo "./launchClient.sh kafka create"
}

if [ -z $1 ];
then
    echo "Using default config"
    CONFIG_TYPE="config"
else
    CONFIG_TYPE=$1
fi

export CALIPER_FABRICCCP_SKIPCREATECHANNEL_MYCHANNEL=true

if [ "$2" == "create" ];
then
    echo "Creating channel"
    export CALIPER_FABRICCCP_SKIPCREATECHANNEL_MYCHANNEL=false
else
	echo "Skipping channel creation"
fi

# pids=`ps ax | grep -i 'http.server' | grep -v grep | awk '{print $1}'`
# for pid in $(eval echo $pids)
# do
# 	echo "########### kill -9 $pid #############"
# 	kill -9 $pid
# done

# pids=`ps ax | grep -i 'cliffton.io' | grep -v grep | awk '{print $1}'`
# for pid in $(eval echo $pids)
# do
# 	echo "########### kill -9 $pid #############"
# 	kill -9 $pid
# done

export BENCHMARK=fabric-ccp


mkdir -p $HOME/reports 

# cd $HOME/caliper/packages/caliper-tests-integration/reports/
# python3 -m http.server 8888 &> http-server.log &
# ssh -f -N -T -R 3333:localhost:8888 cliffton &


CALIPER_ROOT=$HOME/caliper/packages/caliper-samples


caliper benchmark run -c "$CALIPER_ROOT"/benchmark/simple/config.yaml -n "$CALIPER_ROOT"/network/fabric-v1.4/"$CONFIG_TYPE"/fabric-ccp-node.yaml -w "$CALIPER_ROOT"/
