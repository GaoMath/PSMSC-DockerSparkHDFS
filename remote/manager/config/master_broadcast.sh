#!/bin/bash
#title           :master-broadcast.sh
#description     :Display the master's RSA public key.
#author		 :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage		 :./master-broadcast.sh
#notes           :RSA key has to be created.
#bash_version    :4.4.19(1)-release
#==============================================================================

cat ~/.ssh/id_rsa.pub
