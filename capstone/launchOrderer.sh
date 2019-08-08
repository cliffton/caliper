#!/bin/bash

# set -x

export CALIPER_FABRIC=$HOME/caliper/packages/caliper-samples/network/fabric-v1.4/


function usage {
    echo "./launchOrderer.sh ORDERER_ID kafka"
}

# Check if ORG_NAME passed
if [ -z $1 ];
then
    usage
    echo "Please provide the ORDERER_ID!!!"
    exit 0
else
    ORDERER_ID=$1
fi


if [ -z $2 ];
then
    echo "Using default config"
    CONFIG_TYPE="config"
else
    CONFIG_TYPE=$2
fi


pids=`ps ax | grep -i 'orderer' | grep -v grep | awk '{print $1}'`
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
mkdir -p $HOME/orderer/msp/orderer
mkdir -p $HOME/orderer/ledger
mkdir -p $HOME/orderer/configtx

export FABRIC_LOGGING_SPEC="grpc=debug:debug"
export ORDERER_GENERAL_LISTENADDRESS="0.0.0.0"
export ORDERER_GENERAL_GENESISMETHOD="file"
export ORDERER_GENERAL_GENESISFILE="$HOME"/orderer/configtx/genesis.block
export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"
export ORDERER_GENERAL_LOCALMSPDIR="$HOME"/orderer/msp/orderer/msp
export ORDERER_KAFKA_VERBOSE="true"
export ORDERER_FILELEDGER_LOCATION="$HOME"/orderer/ledger
export ORDERER_GENERAL_LOGLEVEL="debug"
export FABRIC_CFG_PATH="$HOME"/orderer


cd $HOME/caliper/packages/caliper-samples/network/fabric-v1.4/"$CONFIG_TYPE"
cp orderer.yaml "$HOME"/orderer/
cp -r ./config/* "$HOME"/orderer/configtx/
cp -r ./config/crypto-config/ordererOrganizations/example.com/orderers/orderer"$ORDERER_ID".example.com/* "$HOME"/orderer/msp/orderer/
cd $HOME/go/src/github.com/hyperledger/fabric/

# set +x 

orderer &> $HOME/orderer/orderer.log &


pid=$!
sleep 5

# pid=`ps ax | grep -i 'orderer' | grep -v grep | awk '{print $1}'`

python3 $HOME/caliper/capstone/processMonitor.py 9001 $pid &> $HOME/orderer/monitor.log &