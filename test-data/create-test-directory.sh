#!/bin/bash

# Initial version has been created by Arsen Kairkanov  18 April 2014
# Correction by Shevel.Andrey@gmail.com Fri Apr 18 18:44:51 MSK 2014
# Correction by Arsen Kairkanov  23 April 2014
# Correction by Arsen Kairkanov 19 August 2014

function print_usage() {
    cat <<EOF
        "-h"|"--help"         show this text
        "-q"|"--quite"        by default false
        "-l"|"--logfile"      by default $0\.log
        "-n"|"--dirname"      by default ./test_directory
        "-z"|"--dirsize"      by default 1024 KiB
        "-f"|"--filesize"     by default 102 KiB
        "-d"|"--dispersion"   by default 10 KiB
        "-s"|"--sample"       by default /dev/urandom
	"-b"|"--block-size"   by default 1K

E.g. 2 ways to creating 1TiB directory with 100MiB-files, dispersion 50 MiB: 

$0 -n test -z 1073741824 -f 102400 -d 51200 -s /dev/zero
$0 -n test -z 1048576    -f 100    -d 50    -s /dev/zero -b 1M 

NOTE: If you change block-size, check your free disk space before starting.

EOF
}

logger=$0\.log

function logit {
    if [[ $quiet == "true" ]]
    then
	echo $1 1>> $logger
    else
	echo $1 |tee -a $logger
    fi
}

logit "Initializing `date`"

DIRECTORY_NAME=./test_directory
DIRECTORY_SIZE=1024
AVERAGE_SIZE=102
DISPERSION=10
SAMPLE_DESTINATION=/dev/urandom

BLOCK_SIZE=1K
SAMPLE_FILE=./sample


while [[ $# -gt 0 ]]; do
    opt="$1"
    shift;
    current_arg="$1"
    case "$opt" in
        "-h"|"--help"         ) print_usage; exit 1;;
        "-q"|"--quite"        ) quiet='true'; shift;;
        "-l"|"--logfile"      ) logger="$1";  shift;;
        "-n"|"--dirname"      ) DIRECTORY_NAME="$1";  shift;;
        "-z"|"--dirsize"      ) DIRECTORY_SIZE="$1"; shift;;
        "-f"|"--filesize"     ) AVERAGE_SIZE="$1"; shift;;
        "-d"|"--dispersion"   ) DISPERSION="$1"; shift;;
        "-s"|"--sample"       ) SAMPLE_DESTINATION="$1"; shift;;
	"-b"|"--block-size"   ) BLOCK_SIZE="$1"; shift;;
        *                     ) echo "ERROR: Invalid option: \""$opt"\"" >&2
	                       print_usage; exit 1;;
    esac
done


mkdir $DIRECTORY_NAME 

######## Checking free disk space in directory ########
FREE_DISK_SPACE=`df -k $DIRECTORY_NAME | awk '/[0-9]%/{print $(NF-2)}'`
if [[ $FREE_DISK_SPACE -lt $DIRECTORY_SIZE && $BLOCK_SIZE == 1K ]]
then 
    cat <<EOF 
No free disk space in directory.
Please, check script arguments or change the directory.
EOF
    exit 0
fi

cd $DIRECTORY_NAME

######## Creating sample-file ########
function create-sample() {
    dd if=$SAMPLE_DESTINATION of=$SAMPLE_FILE bs=$BLOCK_SIZE count=$(( $AVERAGE_SIZE + $DISPERSION ))  conv=notrunc oflag=append
      
}

######## Creating files in directory ########
function create-files() {
    NUMBER_OF_FILES=$(( $DIRECTORY_SIZE / $AVERAGE_SIZE ))
    COUNT=1
    while [ $COUNT -le $NUMBER_OF_FILES ]
    do
	SIZE=`python -S -c "import random; print int(random.gauss($AVERAGE_SIZE, $DISPERSION)) "`
	dd if=$SAMPLE_FILE of=$COUNT bs=$BLOCK_SIZE count=$SIZE
	COUNT=$[$COUNT + 1]
    done
}

create-sample
create-files
 
rm -f $SAMPLE_FILE

ls -lth 
