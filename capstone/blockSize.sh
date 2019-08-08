#!/bin/bash

cd ../packages/caliper-samples/network/fabric-v1.4/kafka/config/
rm genesis.block mychannel.tx
configtxgen -profile OrdererGenesis -outputBlock genesis.block -channelID syschannel
configtxgen -profile ChannelConfig -outputCreateChannelTx mychannel.tx -channelID mychannel


git add .
git commit -m " Genesis Block Creation"
git push origin cpu

cd -
./restartNetwork.sh
