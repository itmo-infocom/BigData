#!/bin/bash
#set -x

. ./settings

for i in 1 2 3 4 18 26 50 64 
do
	grep -r 'Average transfer speed' $TEST.$DATE/s$i | sort | awk '{print NR, $6}' > DataSpeed-$TEST.s$i
done

./DataSpeed.plot.sh 2>&1 | tee DataSpeed-$TEST.$DATE.plot | gnuplot > DataSpeed-$TEST.$DATE.ps; convert DataSpeed-$TEST.$DATE.ps DataSpeed-$TEST.$DATE.pdf; convert DataSpeed-$TEST.$DATE.pdf DataSpeed-$TEST.$DATE.jpg; evince DataSpeed-$TEST.$DATE.pdf; eog DataSpeed-$TEST.$DATE.jpg
