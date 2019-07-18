START_NODE=1
END_NODE=166


for ip in $(eval echo {$START_NODE..$END_NODE})
do
	echo "########### Running $MY_CMD on 10.10.10.$ip #############"
	ssh atomicpi@10.10.10.$ip $MY_CMD  
	echo " "
done