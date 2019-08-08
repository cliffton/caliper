#!/bin/bash

export CALIPER_KAFKA=$HOME/caliper/packages/caliper-samples/network/fabric-v1.4/kafka/


set -x

function usage {
    echo "./launch_peer.sh ORG_ID PEER_ID"
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

rm -rf $HOME/peer/*
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


cp core.yaml $HOME/peer/
cp -r ./config/crypto-config/peerOrganizations/org"$ORG_ID".example.com/peers/"$CORE_PEER_ID"/* $HOME/peer/
cp -r ./config/mychannel.tx $HOME/peer/configtx/mychannel.tx
cp -r ./config/crypto-config/peerOrganizations/org"$ORG_ID".example.com/users $HOME/peer/msp/

cd $HOME/go/src/github.com/hyperledger/fabric
peer node start