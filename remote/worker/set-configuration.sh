#!/bin/bash
#title           :set-configuration.sh
#description     :Set the environment variables.
#author          :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage           :source ./set-configuration.s
#notes           :The IP addresses have to be static.
#bash_version    :4.4.19(1)-release
#==============================================================================

export HADOOPSPARK_MANAGER_USER="admin"
export HADOOPSPARK_MANAGER_IP="192.168.1.36"
export HADOOPSPARK_WORKER_IP="192.168.1.101"
