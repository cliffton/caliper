#!/bin/bash


## Clean Everything
./killAll.sh


## Start Zookeepers
./updateNodes.sh 166 168 'cd ~/caliper/capstone/ && ./launchZookeeper.sh'


## Start Kafka Nodes
./updateNodes.sh 169 172 'cd ~/caliper/capstone/ && ./launchKafka.sh'


## Start Orderers 
./updateNodes.sh 173 174 'cd ~/caliper/capstone/ && ./launchOrderer.sh'


## Start Peers
./updateNodes.sh 175 176 'cd ~/caliper/capstone/ && ./launchPeer.sh'



# Just checking
./updateNodes.sh 169 172 'ls -l /data/kafka/'