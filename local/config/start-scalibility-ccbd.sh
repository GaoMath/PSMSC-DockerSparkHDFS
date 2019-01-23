#!/bin/bash

F="file-wordcount.txt"
T="times.log"

rm -f $T

echo "create the first file..."
cat $F $F $F $F $F $F $F $F $F $F $F $F $F $F $F $F > tmp
cat tmp tmp tmp tmp tmp tmp tmp tmp tmp tmp > tmp2
cat tmp2 tmp2 tmp2 tmp2 tmp2 > $F
rm -f tmp tmp2

for i in {1..4}
do
        echo "create of the file $i..."
        cat $F $F > tmp
        rm -f $F
        mv tmp $F

        ./start-wordcount.sh
        du -sh $F >> $T
        cat /tmp/time-wordcount.log | grep real | awk '{ print $2 }' >> $T
        rm -rf output
done
