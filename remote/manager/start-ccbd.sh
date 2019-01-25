#!/bin/bash
#title           :start-ccbd.sh
#description     :Launch the CCBD containers.
#author		 :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage		 :sudo ./start-ccbd.sh [OPTION]
#notes           :Install docker to use this script.
#bash_version    :4.4.19(1)-release
#==============================================================================

DOCKER_IMG="spark-hadoop"
DOCKER_TAG="latest"
DOCKER_BRG="hadoop"
HADOOP_MASTER="hadoop-master"
HADOOP_SLAVE="hadoop-slave"
NBEGIN=1
N=${1:-3}
NREMOTE=${2:-2}

usage() {
    echo "Usage: sudo ./start-ccbd.sh [ARGUMENT]"
    echo -e "\nLaunch the CCBD containers."
    echo -e "\nArgument:"
    echo -e "\tN\tThe number of containers to launch (default: 3)"
    echo -e "\tNR\tThe number of remote slaves (default: 2)"
}

# set the environment variables
source ./set-configuration.sh

# start the swarm server
docker swarm init --advertise-addr=$HADOOPSPARK_MANAGER_IP \
    | grep SWMTKN \
    | awk '{ print $5 }' 2>&1 \
    | tee /tmp/swarm.hadoop-master.tkn

# write the hadoop slave file
i=$NBEGIN
rm -f config/slaves
while [ $i -lt $(( $N + $NREMOTE + $NBEGIN - 1 )) ]; do
    echo "$HADOOP_SLAVE$i" >> config/slaves
    i=$(( $i + 1 ))
done

# build the docker image
if [ -z "$(docker images -q $DOCKER_IMG:$DOCKER_TAG)" ]; then
    echo "build the docker image..."
    docker build -t $DOCKER_IMG:$DOCKER_TAG .
fi

# create the docker bridge
echo "create the docker bridge..."
docker network create --driver=overlay --attachable $DOCKER_BRG

# run the hadoop master container
docker rm -f $HADOOP_MASTER &> /dev/null

echo "run the hadoop master container..."
docker run -itd \
           --net=$DOCKER_BRG \
           -p 50070:50070 \
           -p 8088:8088 \
           -p 7077:7077 \
           -p 16010:16010 \
           --name $HADOOP_MASTER \
           --hostname $HADOOP_MASTER \
           $DOCKER_IMG:$DOCKER_TAG

# run the hadoop slave containers
i=$NBEGIN
while [ $i -lt $(( $N + $NBEGIN - 1 )) ]; do
    docker rm -f $HADOOP_SLAVE$i &> /dev/null

    echo "run the hadoop slave$i container..."
    port=$(( 8040 + $i ))
    docker run -itd \
               -p $port:8042 \
               --net=$DOCKER_BRG \
               --name $HADOOP_SLAVE$i \
               --hostname $HADOOP_SLAVE$i \
               $DOCKER_IMG:$DOCKER_TAG
    i=$(( $i + 1 ))
done

# run hadoop file system on the hadoop master container
docker exec $HADOOP_MASTER master_broadcast.sh > /tmp/id_rsa.hadoop-master.pub
cat /tmp/id_rsa.hadoop-master.pub >> /home/tom/.ssh/authorized_keys

# get into hadoop master container
docker exec -it $HADOOP_MASTER bash
