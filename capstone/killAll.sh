#!/bin/bash


## Kill Zookeepers
./updateNodes.sh 166 168 'cd ~/caliper/capstone/kill/ && ./cleanZookeeper.sh'


## Kill Kafka Nodes
./updateNodes.sh 169 172 'cd ~/caliper/capstone/kill/ && ./cleanKafka.sh'


## Kill Orderers 
./updateNodes.sh 173 174 'cd ~/caliper/capstone/kill/ && ./cleanOrderer.sh'


## Kill Peers
./updateNodes.sh 175 176 'cd ~/caliper/capstone/kill/ && ./cleanPeer.sh'



# Just checking
./updateNodes.sh 169 172 'ls -l /data/kafka/'