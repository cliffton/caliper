#!/bin/bash


## Update code everywhere.
./updateNodes.sh 166 177 'cd ~/caliper && git pull origin cpu'


## Clean Everything
./killAll.sh


## Start Zookeepers
./updateNodes.sh 166 168 'cd ~/caliper/capstone/ && ./launchZookeeper.sh'


## Start Kafka Nodes
./updateNodes.sh 169 172 'cd ~/caliper/capstone/ && ./launchKafka.sh'


## Start CAs
./updateNodes.sh 173 173 'cd ~/caliper/capstone/ && ./launchCA.sh 0 kafka'
./updateNodes.sh 174 174 'cd ~/caliper/capstone/ && ./launchCA.sh 1 kafka'

## Start Orderers 
./updateNodes.sh 173 173 'cd ~/caliper/capstone/ && ./launchOrderer.sh 0 kafka'
./updateNodes.sh 174 174 'cd ~/caliper/capstone/ && ./launchOrderer.sh 1 kafka'


## Start Peers
./updateNodes.sh 175 175 'cd ~/caliper/capstone/ && ./launchPeer.sh 1 0 kafka'
./updateNodes.sh 176 176 'cd ~/caliper/capstone/ && ./launchPeer.sh 2 0 kafka'



# Just checking
./updateNodes.sh 169 172 'ls -l /data/kafka/'