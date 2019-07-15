#!/bin/bash

cp ./config/crypto-config/peerOrganizations/org2.example.com/ca/* ~/fabric-ca-server/fabric-ca-server-config/
export FABRIC_CA_HOME="$HOME/fabric-ca-server"
export FABRIC_CA_SERVER_CA_NAME="ca.org2.example.com"
export FABRIC_CA_SERVER_CA_CERTFILE="$FABRIC_CA_HOME/fabric-ca-server-config/ca.org1.example.com-cert.pem"
export FABRIC_CA_SERVER_CA_KEYFILE="$FABRIC_CA_HOME/fabric-ca-server-config/key.pem"
fabric-ca-server start -b admin:adminpw -d