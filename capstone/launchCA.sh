#!/bin/bash

export CALIPER_FABRIC=$HOME/caliper/packages/caliper-samples/network/fabric-v1.4/

# set -x

function usage {
    echo "./launch_ca.sh ORG_ID"
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
    echo "Using default config"
    CONFIG_TYPE="config"
else
    CONFIG_TYPE=$2
fi


# pkill -9 fabric-ca-server
# pkill -9 tail
rm -rf $HOME/fabric-ca-server/
mkdir -p $HOME/fabric-ca-server/fabric-ca-server-config
mkdir -p $HOME/fabric-ca-server/msp


export CA_NAME=ca.org"$ORG_ID".example.com
export FABRIC_CA_HOME="$HOME"/fabric-ca-server
export FABRIC_CA_SERVER_CA_NAME=$CA_NAME
export FABRIC_CA_SERVER_CA_CERTFILE="$FABRIC_CA_HOME"/fabric-ca-server-config/"$CA_NAME"-cert.pem
export FABRIC_CA_SERVER_CA_KEYFILE="$FABRIC_CA_HOME"/fabric-ca-server-config/key.pem

cd $HOME/caliper/packages/caliper-samples/network/fabric-v1.4/"$CONFIG_TYPE" 
cp ./config/crypto-config/peerOrganizations/org"$ORG_ID".example.com/ca/* "$HOME"/fabric-ca-server/fabric-ca-server-config/
cd $HOME/fabric-ca-server/

# set +x

# fabric-ca-server start -b admin:adminpw -d &> fabric-ca-server.log
