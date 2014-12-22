#!/bin/bash
#set -x
#--------------------------------------------------------------------------
#
# Usage: RunTop.sh  <logfile> <interval>
#
# the script is invoked by bigdata scripts and designed to write output of command ' top -ibn 1'
# to <logfile> every <interval> seconds
#
# Creation date: Thu Dec  4 10:47:25 MSK 2014
# by Anatoly  Oreshkin   email:  anatoly.oreshkin@gmail.com
#---------------------------------------------------------------------------
# History of changes:
#
#----------------------------------------------------------------------------

export LANG=C

if [ "$#" -ne 2 ]; then

    cat <<END
-----------------------------------------------------------------------------------
 the script is designed to write output of command 'top -ibn 1'
 to <logfile> every <interval> seconds(default)


  Usage: $0 <logfile> <interval>  
            
               logfile -- log file to write output of command 'top -ibn 1'
               interval -- interval in seconds(default), suffix may be 'm' for minutes,
                           'h' for hours,  'd' for days 
-----------------------------------------------------------------------------------
END
   exit 1
fi

LOGFILE=$1
INTERVAL=$2
TOPPID=$$  # PID of this process

#
# running command 'top' to get CPU & Memory usage
#

(
while : 
  do
    top -ibn 1
    echo "--------------------------------------------------------------"
    sleep ${INTERVAL}
# check if main script cancelled or finished
    if [ ! -d /proc/${TOPPID} ]; then
#      echo "Invoking script  is finished or cancelled"
     exit 1
    fi
    # parent PID
    TOPPPID=`cat /proc/${TOPPID}/status|grep PPid | awk -F" " '{print $2}'`
    if [ "${TOPPPID}" -eq 1 ]; then
#      echo "Invoking script  is finished or cancelled"
     exit 1
    fi
  done

) > ${LOGFILE} 2>&1

