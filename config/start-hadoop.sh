#!/bin/bash
#title           :start-hadoop.sh
#description     :Start the Hadoop file system and yarn.
#author		 :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage		 :sudo ./start-hadoop.sh [OPTION]
#notes           :Install hadoop to use this script.
#bash_version    :4.4.19(1)-release
#==============================================================================

$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
