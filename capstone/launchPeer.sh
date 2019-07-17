#!/bin/bash

export CALIPER_FABRIC=$HOME/caliper/packages/caliper-samples/network/fabric-v1.4/kafka/


# set -x

function usage {
    echo "./launchPeer.sh ORG_ID PEER_ID kafka"
}

# Check if ORG_NAME passed
if [ -z $1 ];
then
    usage
    echo "Please provide the ORG ID!!!"
    exit 0
else
    ORG_ID=$1
fi

if [ -z $2 ];
then
    usage
    echo  "Please specify PEER ID!!!"
    exit 0
else
    PEER_ID=$2
fi


if [ -z $3 ];
then
    echo "Using default config"
    CONFIG_TYPE="config"
else
    CONFIG_TYPE=$3
fi



pids=`ps ax | grep -i 'peer' | grep -v grep | awk '{print $1}'`
for pid in $(eval echo $pids)
do
	echo "########### kill -9 $pid #############"
	kill -9 $pid
done

rm -rf $HOME/peer
mkdir -p $HOME/peer/ledger
mkdir -p $HOME/peer/configtx
mkdir -p $HOME/peer/msp


export FABRIC_CFG_PATH=$HOME/peer/
export FABRIC_LOGGING_SPEC="grpc=debug:debug"
export CORE_CHAINCODE_LOGGING_LEVEL="INFO"
export CORE_CHAINCODE_LOGGING_SHIM=INFO
export CORE_PEER_ID=peer"$PEER_ID".org"$ORG_ID".example.com
export CORE_PEER_ENDORSER_ENABLED=true
export CORE_PEER_LOCALMSPID=Org"$ORG_ID"MSP
export CORE_PEER_MSPCONFIGPATH=$HOME/peer/msp/
export CORE_PEER_ADDRESS=peer"$PEER_ID".org"$ORG_ID".example.com:7051
export CORE_PEER_GOSSIP_USELEADERELECTION=true
export CORE_PEER_GOSSIP_ORGLEADER=false
export CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer"$PEER_ID".org"$ORG_ID".example.com:7051
export CORE_PEER_FILESYSTEMPATH=$HOME/peer/ledger/

cd $HOME/caliper/packages/caliper-samples/network/fabric-v1.4/"$CONFIG_TYPE"
cp core.yaml $HOME/peer/
cp -r ./config/crypto-config/peerOrganizations/org"$ORG_ID".example.com/peers/"$CORE_PEER_ID"/* $HOME/peer/
cp -r ./config/mychannel.tx $HOME/peer/configtx/mychannel.tx
cp -r ./config/crypto-config/peerOrganizations/org"$ORG_ID".example.com/users $HOME/peer/msp/

cd $HOME/go/src/github.com/hyperledger/fabric
peer node start &> $HOME/peer/peer.log &