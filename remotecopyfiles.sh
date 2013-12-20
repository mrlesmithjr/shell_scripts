#!/bin/bash
#Provided by @mrlesmithjr
#EveryThingShouldBeVirtual.com
#
# This script will prompt for needed info to copy a file to a remote server using scp and then move it to the final destination of choice
#
echo -n "Enter remote servername: "
read remoteservername
echo -n "Enter username to connect with: "
read remoteusername
echo -n "Enter path where file is to send: "
read filepath
echo -n "Enter filename to send: "
read filetosend
echo -n "Enter remote path (final destination): "
read remotepath
 
scp $filepath/$filetosend $remoteusername@$remoteservername:/tmp
ssh -t $remoteusername@$remoteservername sudo mv /tmp/$filetosend $remotepath/
#ls -l $remotepath | ssh $remoteusername@$remoteservername
exit
