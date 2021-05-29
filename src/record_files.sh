#!/bin/bash
# We load just one service and its config.

set -x
servicename=$1
logfile=/var/log/rtspcollector.log

typeset -A config
config=(
  [devicename]="channel"	
  [username]="admin"
  [password]=""
  [deviceaddress]="192.168.1.100"
)

foundsection=false
existfirstsection=false

while read line
do
  section=$(echo $line | grep -v "^[[:blank:]]*#.*$" | sed 's/[[:blank:]]//g'| cut -d \# -f 1 |  awk -F'[][]' '{ print $2;  }')
  if [[ "$section" == "$servicename" ]]; then
	  foundsection=true
	  config[devicename]=$section
  fi
  if [[ ! -z "$section" && "$section" != "$servicename" ]]; then
          foundsection=false
  fi
  if [[ $foundsection && -z $section ]]; then
    key=$(echo $line | grep -v "^[[:blank:]]*#.*$" | sed 's/[[:blank:]]//g'| cut -d \# -f 1 | cut -d= -f 1)
    value=$(echo $line | grep -v "^[[:blank:]]*#.*$" | sed 's/[[:blank:]]//g'| cut -d \# -f 1 | cut -d= -f 2)
    if [[ ! -z $key ]]; then
      config[$key]=$value
    fi
  fi
done < /etc/rtspcollector/rtspcollector.conf

mkdir -p /var/spool/micropones/$servicename
cd /var/spool/micropones/$servicename
echo "Run Service $servicename" >> $logfile
echo "openRTSP -a -c -B 10000000 -b 10000000 -F ${config[devicename]}_ -u ${config[username]} ${config[password]}  -d 60 -P 60 rtsp://${config[deviceaddress]}:554/" >> $logfile
openRTSP -a -c -B 10000000 -b 10000000 -F ${config[devicename]}_ -u ${config[username]} ${config[password]}  -d 60 -P 60 rtsp://${config[deviceaddress]}:554/  >> $logfile  2>&1 

#openRTSP 

#filename=blabla
#sox -r 16k -t al -c 1 $file /tmp/$file.wav
#lame /tmp/mega_10.wav 




