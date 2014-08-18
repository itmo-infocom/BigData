#!/bin/bash
#set -x
#--------------------------------------------------------------------------
#
# Usage: set-passwordless-ssh.sh [<RemoteUser>@]<RemoteHost>
#
# the script is designed to  set passwordless ssh login
#
# Creation date: Mon Aug 18 15:02:54 MSK 2014
# by Anatoly  Oreshkin   email:  anatoly.oreshkin@gmail.com
#---------------------------------------------------------------------------
# History of changes:
#
#----------------------------------------------------------------------------

#
#  check  command line parameters
#

if [ "$#" -lt 1 ]; then

    cat <<END


------------------------------------------------------------------------------------------------

  the script is designed to set  passwordless ssh login

 Usage: $0  [<RemoteUser>@]<RemoteHost>

------------------------------------------------------------------------------------------------
END
   exit 1
fi

LOCAL_USER=`whoami`

# check if REMOTE_USER specified
REMOTE_HOST=`echo $1 | awk -F"@" '{print $2}'`
if [ -z ${REMOTE_HOST} ]; then
  REMOTE_HOST=$1
  REMOTE_USER=${LOCAL_USER}
else
  REMOTE_USER=`echo $1 | awk -F"@" '{print $1}'`
  REMOTE_HOST=`echo $1 | awk -F"@" '{print $2}'`
fi


#
#  generate SSH RSA private and public keys without passphrase
#


echo "-------------------------------------------------------------" 
echo " Generate SSH RSA private and public keys without passphrase "
echo "-------------------------------------------------------------"


if [ -f ~/.ssh/id_rsa ]; then
  echo
  echo " File ~/.ssh/id_rsa already exists --> then bypass generate RSA keys"
  echo
else
  ssh-keygen -t rsa -N ""
fi

echo "---------------------------------------------------------------------"
echo " Copy public key to remote ssh server '${REMOTE_USER}@${REMOTE_HOST}'  "
echo "---------------------------------------------------------------------"


cat ~/.ssh/id_rsa.pub | ssh ${REMOTE_USER}@${REMOTE_HOST} 'cat >> ~/.ssh/authorized_keys'

