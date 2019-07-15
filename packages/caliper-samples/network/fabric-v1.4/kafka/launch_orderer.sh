#!/bin/bash

set -x

function usage {
    echo "./launch_orderer.sh ORG_ID"
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

export FABRIC_LOGGING_SPEC="grpc=debug:debug"
export ORDERER_GENERAL_LISTENADDRESS="0.0.0.0"
export ORDERER_GENERAL_GENESISMETHOD="file"
export ORDERER_GENERAL_GENESISFILE="$HOME"/orderer/configtx/genesis.block
export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"
export ORDERER_GENERAL_LOCALMSPDIR="$HOME"/orderer/msp/
export ORDERER_KAFKA_VERBOSE="true"
export ORDERER_FILELEDGER_LOCATION="$HOME"/orderer/ledger
export ORDERER_GENERAL_LOGLEVEL="debug"
export FABRIC_CFG_PATH="$HOME"/orderer


cp orderer.yaml $HOME/orderer/
cp -r ./config/* $HOME/orderer/configtx/
cp -r ./config/crypto-config/ordererOrganizations/example.com/orderers/orderer"ORG_ID".example.com/* $HOME/orderer/msp/
cd $HOME/go/src/github.com/hyperledger/fabric/
orderer