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

init() {
    echo "stop all containers..."
    docker stop $(docker ps -a -q) &> /dev/null
    docker rm $(docker ps -a -q) &> /dev/null

    echo "remove all docker network..."
    docker network rm $(docker network ls -q) &> /dev/null

    rm -f config/slaves
}

if [[ ! $@ =~ ^\-.+ ]]; then
    init
else
    while getopts ":hi" opt; do
        case ${opt} in
            h ) usage
              ;;
            i ) init

                echo "remove docker image..."
                docker rmi -f $DOCKER_IMG:$DOCKER_TAG
              ;;
            \? ) echo -e "Invalid option: $OPTARG\n" 1>&2
                 usage
              ;;
        esac
    done
fi
