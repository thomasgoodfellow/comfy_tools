#!/bin/bash
VM="drinfeld"
HOST="mccarthy"
[ "$1" != "" ] && VM=$1
[ "$2" != "" ] && HOST=$2
echo "Try $VM start on $HOST"
ssh $HOST "/opt/site/bin/vmup.sh $VM &"
for ((i = 1; i <= 30; i++)); do
  echo "Waiting for $VM ping reply (try #$i)"
  ping -w 30 -c 2 -v $VM.ddns.lcl
  if [ $? -eq 0 ] ; then 
	break 
  fi
done
xfreerdp -k de -a 16 -z -x 1D --sec rdp --plugin cliprdr --plugin rdpdr --data disk:P:/home/thomasg -- -f $VM
