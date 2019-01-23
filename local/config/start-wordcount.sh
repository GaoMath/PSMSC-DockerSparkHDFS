#!/bin/bash
#title           :start-wordcount.sh
#description     :Launch the wordcount example.
#author		 :Guillaume Hugonnard and Tom Ragonneau
#date            :20190113
#version         :1.0
#usage		 :sudo ./start-wordcount.sh [OPTION]
#notes           :Install hadoop to use this script.
#bash_version    :4.4.19(1)-release
#==============================================================================

INPUT="input"
OUTPUT="output"
FILE="file-wordcount.txt"
FTIME="/tmp/time-wordcount.log"

if [ -f "$FILE" ]; then
    echo "create the hadoop input directory..."
    hadoop fs -mkdir -p $INPUT &> /dev/null
    hadoop fs -rm -f $INPUT/$FILE &> /dev/null

    echo "delete the hadoop output directory..."
    hadoop fs -rm -r -f $OUTPUT &> /dev/null

    echo "put $FILE into the hadoop input directory..."
    hadoop fs -put $FILE $INPUT &> /dev/null

    echo "launch the Spark WordCountTask..."
    ( time spark-submit --class wct.WordCountTask \
                        --master yarn \
                        --deploy-mode cluster \
                        --driver-memory 4g \
                        --executor-memory 2g \
                        --executor-cores 1 \
                        wordcount.jar \
                        $INPUT/$FILE \
                        $OUTPUT ) |& tee /tmp/$FILE.log
    cat /tmp/$FILE.log | tail -n 3 > $FTIME
    rm -f /tmp/$FILE.log

    echo "get the output in the current directory..."
    hadoop fs -get $OUTPUT &> /dev/null
else
    echo "No such file: $FILE not found."
fi
