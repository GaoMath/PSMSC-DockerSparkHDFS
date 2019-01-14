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
N=${1:-3}

usage() {
    echo "Usage: sudo ./start-ccbd.sh [ARGUMENT]"
    echo -e "\nLaunch the CCBD containers."
    echo -e "\nArgument:"
    echo -e "\tN\tThe number of containers to launch (default: 3)"
}

# write the hadoop slave file
i=1
rm -f config/slaves
while [ $i -lt $N ]; do
    echo "$HADOOP_SLAVE$i" >> config/slaves
    i=$(( $i + 1 ))
done

# build the docker image
if [ -z "$(docker images -q $DOCKER_IMG:$DOCKER_TAG)" ]; then
    echo "build the docker image..."
    sudo docker build -t $DOCKER_IMG:$DOCKER_TAG .
fi

# create the docker bridge
echo "create the docker bridge..."
sudo docker network create --driver=bridge $DOCKER_BRG

# run the hadoop master container
sudo docker rm -f $HADOOP_MASTER &> /dev/null

echo "run the hadoop master container..."
sudo docker run -itd \
                --net=$DOCKER_BRG \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 7077:7077 \
                -p 16010:16010 \
                --name $HADOOP_MASTER \
                --hostname $HADOOP_MASTER \
                $DOCKER_IMG:$DOCKER_TAG &> /dev/null

# run the hadoop slave containers
i=1
while [ $i -lt $N ]; do
    sudo docker rm -f $HADOOP_SLAVE$i &> /dev/null

    echo "run the hadoop slave$i container..."
    port=$(( 8040 + $i ))
    sudo docker run -itd \
                    -p $port:8042 \
                    --net=DOCKER_BRG \
                    --name $HADOOP_SLAVE$i \
                    --hostname $HADOOP_SLAVE$i \
                    $DOCKER_IMG:$DOCKER_TAG &> /dev/null
    i=$(( $i + 1 ))
done

# run hadoop file system on the hadoop master container
sudo docker exec $HADOOP_MASTER /usr/local/bin/start-hadoop.sh

# get into hadoop master container
sudo docker exec -it $HADOOP_MASTER bash
