#!/bin/bash
# Convert to and store the files by a time group.
set -x

typeset -i lastmodifyfile
typeset -i longrecord
longrecord=60

find /var/spool/micropones/raw/  -type f -mmin +3 -print0| while IFS= read -r -d '' alawfile
do
  nameservice=$(basename $(dirname $alawfile))
  lastmodifyfile=$(stat --format=%Y $alawfile)
  creationdate=$(expr $lastmodifyfile - $longrecord)
  sox -r 16k -t al -c 1 $alawfile /tmp/$(basename $alawfile).wav
  rm -f $alawfile
  mkdir -p  /var/spool/micropones/mp3/$nameservice/$(date -d @$creationdate '+%m/%d/%H')
  lame  -h /tmp/$(basename $alawfile).wav /var/spool/micropones/mp3/$nameservice/$(date -d @$creationdate '+%m/%d/%H')/$(date -d @$creationdate '+%M_%S').mp3 1>/dev/null 2>/dev/null
  touch -a -m -t $(date "+%Y%m%d%H%M.%S" -d @$creationdate)  /var/spool/micropones/mp3/$nameservice/$(date -d @$creationdate '+%m/%d/%H')/$(date -d @$creationdate '+%M_%S').mp3
  rm -f  /tmp/$(basename $alawfile).wav 
done 

