#!/bin/bash
#set -x
#--------------------------------------------------------------------------
#
# Usage: PortRange  <port-range> [<utility-to-test>]
#
# the script is designed to test what ports are used by utility-to-test
#
# For CopyData.bbftp    such utility is bbftp
# for CopyData.bbcp     such utility is bbcp
# for CopyData.gridftp  such utility is globus-url-copy
#
# If <utility-to-test> is not specifyed all processes which have
# tcp-connection with port range specified are listed
#
# Creation date: Thu Dec 18 19:18:40 MSK 2014
# by Vladimir Titov   email:  tit@astro.spbu.ru
#---------------------------------------------------------------------------

usage () {
  echo ""; echo "    At least one parameter should be specified."
  echo ""; echo "    Call:"
  echo ""; echo "        $0 <port-range> [<utility-to-test>]"; echo ""
  exit
}
if test $# -lt 1; then usage; fi

UTILITY=${2:-}
PORTRANGE=$1
IFS=""
OPENPORTS=`lsof -i TCP:$PORTRANGE || \
                       (echo "No open sockets in range $PORTRANGE"; exit)`

RESULT=$(echo $OPENPORTS|tail -n +2 |gawk '{ print $1, $2, $8, $9, $10 }')

if test -z "$UTILITY"
  then
     test ! -z  $RESULT && (echo "CMND PID PROT    SRC->DEST"; echo $RESULT)
  else
     RESUTIL=`echo "$RESULT" | grep -e "^$UTILITY\ "`
     test ! -z  $RESUTIL && (echo "CMND PID PROT    SRC->DEST"; echo $RESUTIL)
fi

