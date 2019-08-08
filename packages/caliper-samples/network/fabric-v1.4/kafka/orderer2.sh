#!/bin/bash

export FABRIC_LOGGING_SPEC="grpc=debug:debug"
export ORDERER_GENERAL_LISTENADDRESS="0.0.0.0"
export ORDERER_GENERAL_GENESISMETHOD="file"
export ORDERER_GENERAL_GENESISFILE="$HOME/orderer/configtx/genesis.block"
export ORDERER_GENERAL_LOCALMSPID="OrdererMSP"
export ORDERER_GENERAL_LOCALMSPDIR="$HOME/orderer/msp/orderer/msp"
export ORDERER_KAFKA_VERBOSE="true"
export ORDERER_FILELEDGER_LOCATION="$HOME/orderer/ledger"
export ORDERER_GENERAL_LOGLEVEL="debug"
export FABRIC_CFG_PATH="$HOME/orderer"


cp orderer.yaml $HOME/orderer/
cp -r ./config/* $HOME/orderer/configtx/
cp -r ./config/crypto-config/ordererOrganizations/example.com/orderers/orderer1.example.com/* $HOME/orderer/msp/orderer
cd $HOME/go/src/github.com/hyperledger/fabric/
orderer