#!/bin/bash
#title           :reset-ccbd.sh
#description     :Reset the CCBD containers.
#author		 :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage		 :sudo ./reset-ccbd.sh [OPTION]
#notes           :Install docker to use this script.
#bash_version    :4.4.19(1)-release
#==============================================================================

DOCKER_IMG="spark-hadoop"
DOCKER_TAG="latest"

usage() {
	echo "Usage: sudo ./reset-ccbd.sh [OPTION]"
	echo -e "\nReset the CCBD containers."
	echo -e "\nOptions:"
	echo -e "\t-h\tThe help menu"
	echo -e "\t-i\tRemove the docker image"
}

echo "stop all containers..."
sudo docker stop $(docker ps -a -q) &> /dev/null

while getopts ":hi" opt; do
	case ${opt} in
		h ) usage
		  ;;
		i ) echo "remove docker image..."
                    sudo docker rmi -f $DOCKER_IMG:$DOCKER_TAG 2> /dev/null
		  ;;
		\? ) echo "Invalid option: $OPTARG" 1>&2
		  ;;
	esac
done

echo "remove all docker network..."
sudo docker network rm $(docker network ls -q) &> /dev/null
