#!/bin/bash
#title           :set-ports.sh
#description     :Open the required ports.
#author          :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage           :sudo ./set-ports.sh [OPTION]
#notes           :Need password.
#bash_version    :4.4.19(1)-release
#==============================================================================

sudo ufw allow 2377
sudo ufw allow 7946
sudo ufw allow 4789
