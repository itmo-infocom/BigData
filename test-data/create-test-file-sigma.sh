#!/bin/bash

# Initial version has been created by Arsen Kairkanov  18 April 2014
# Correction by Shevel.Andrey@gmail.com Fri Apr 18 18:44:51 MSK 2014
# Correction by Arsen Kairkanov  23 April 2014

DIRECTORY_NAME=$1
DIRECTORY_SIZE=$2
AVERAGE_SIZE=$3
DISPERSION=$4
SAMPLE_DESTINATION=$5


if [ $# -lt 5 ] 
   then
      cat <<END

$0: The script is dedicated to generate the directory with a number of files \
of different sizes with defined average length and defined dispersion of the \
length.

Usage:  $0 DIRECTORY_NAME DIRECTORY_SIZE(KB) AVERAGE_SIZE(KB) DISPERSION SAMPLE_DESTINATION 



END
   exit 1

fi


NUMBER_OF_FILES=$(( $DIRECTORY_SIZE / $AVERAGE_SIZE ))

SAMPLE_SIZE=`du -k $SAMPLE_DESTINATION | awk '{print $1}'`

mkdir $DIRECTORY_NAME
cd $DIRECTORY_NAME

if [ $AVERAGE_SIZE -le $SAMPLE_SIZE ]
then
    dd if=$SAMPLE_DESTINATION of=./sample bs=1K count=$(($AVERAGE_SIZE + $DISPERSION))
    COUNT=1
    while [ $COUNT -le $NUMBER_OF_FILES ]
    do
    SIZE=`python -S -c "import random; print int(random.gauss($AVERAGE_SIZE, $DISPERSION)) "`
        dd if=./sample of=$COUNT bs=1K count=$SIZE
    COUNT=$[$COUNT + 1]
    done
else
    dd if=$SAMPLE_DESTINATION of=./sample
    dd if=./sample of=./sample bs=1M count=$(( ($AVERAGE_SIZE + $DISPERSION) / 1024))  conv=notrunc oflag=append
    COUNT=1
    while [ $COUNT -le $NUMBER_OF_FILES ]
    do
    SIZE=`python -S -c "import random; print int(random.gauss($AVERAGE_SIZE, $DISPERSION)) "`
    echo $SIZE
    dd if=./sample of=$COUNT bs=1M count=$(($SIZE / 1024))
    COUNT=$[$COUNT + 1]
    done
fi
rm -f ./sample
ls -l --block-size=1K
