#!/bin/bash
WID=$(xdotool getactivewindow)
VM="drinfeld"
HOST="mccarthy"
GEO=1920x1150
[ "$1" != "" ] && VM=$1
[ "$2" != "" ] && HOST=$2
[ "$3" != "" ] && GEO=$3
echo "Try $VM start on $HOST"
ssh $HOST "/opt/site/bin/vmup.sh $VM &"
for ((i = 1; i <= 30; i++)); do
  echo "Waiting for $VM ping reply (try #$i)"
  ping -w 30 -c 2 -v $VM.ddns.lcl
  if [ $? -eq 0 ] ; then 
	break 
  fi
done
xdotool windowminimize $WID
xfreerdp -k de -a 32 -z -x 8D --sec rdp --plugin cliprdr --plugin rdpdr --data disk:P:/home/thomasg -- -g $GEO $VM 
