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
NBEGIN=${1:-3}
N=${1:-2}

usage() {
    echo "Usage: sudo ./start-ccbd.sh [ARGUMENT]"
    echo -e "\nLaunch the CCBD containers."
    echo -e "\nArgument:"
    echo -e "\tN\tThe number of containers to launch (default: 3)"
}

# set the environment variables
source ./set-configuration.sh

rm -f config/id_rsa.hadoop-master.pub
scp $HADOOPSPARK_MANAGER_USER@$HADOOPSPARK_MANAGER_IP:/tmp/id_rsa.hadoop-master.pub config/id_rsa.hadoop-master.pub
scp $HADOOPSPARK_MANAGER_USER@$HADOOPSPARK_MANAGER_IP:/tmp/swarm.hadoop-master.tkn config/swarm.hadoop-master.tkn

HADOOPMASTER_TKN=$(cat config/swarm.hadoop-master.tkn)
docker swarm join --token $HADOOPMASTER_TKN --advertise-addr $HADOOPSPARK_WORKER_IP $HADOOPSPARK_MANAGER_IP:2377

# build the docker image
if [ -z "$(docker images -q $DOCKER_IMG:$DOCKER_TAG)" ]; then
    echo "build the docker image..."
    docker build -t $DOCKER_IMG:$DOCKER_TAG .
fi

# run the hadoop slave containers
i=$NBEGIN
while [ $i -lt $(( $N + $NBEGIN )) ]; do
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
