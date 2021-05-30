#!/bin/bash

GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${GREEN}Install service rtspcollector\@.service${NC}"
cp ./services/rtspcollector\@.service  /etc/systemd/system/
echo -e "${GREEN}Exec command for add autoload service${NC}"
echo -e "${PURPLE}systemctl enable --now  rtspcollector\@NameOfService${NC}"
mkdir -p /usr/local/share/rtsp_collector/
cp ./src/record_files.sh /usr/local/share/rtsp_collector/
cp ./src/convert_alaw_to_mp3.sh /usr/local/share/rtsp_collector/
chmod 755 /usr/local/share/rtsp_collector/record_files.sh
chmod 755 /usr/local/share/rtsp_collector/convert_alaw_to_mp3.sh
conffile=/etc/rtspcollector/rtspcollector.conf
logrotatefile=/etc/logrotate.d/rtspcollector
if [ ! -f "$conffile" ]; then
  echo -n
  echo -e "${GREEN}Copy a default configuration file /etc/rtspcollector/rtspcollector.conf${NC}"
  echo -e "${GREEN}Add into a configuration file section named like NameOfService and configure IP, Login, Password.${NC}"
  cp ./config/rtspcollector.conf /etc/rtspcollector/rtspcollector.conf
fi
if [ ! -f "$logrotatefile" ];then
  cp logrotate/rtspcollector $logrotatefile
fi
echo -n
echo -e "${GREEN}Add the new cron jobs:${NC}"
echo -e "${PURPLE}*/5 * * * * /usr/local/share/rtsp_collector/convert_alaw_to_mp3.sh${NC}"
echo -e "${PURPLE}0 0 * * *  find  /var/spool/micropones/mp3/* -mtime +5 -delete${NC}"

crontab -l |   sed "/^.*convert_alaw_to_mp3.*/d" | sed '/#JOB to convert ALAW to MP3.*/d' | sed '/^.*find.*micropones.*/d' | sed '/#JOB delete old MP3 files.*/d'| { cat; echo "#JOB to convert ALAW to MP3.*"; echo "*/5 * * * * /usr/local/share/rtsp_collector/convert_alaw_to_mp3.sh"; echo "#JOB delete old MP3 files"; echo "0 0 * * *  find  /var/spool/micropones/mp3/* -mtime +5 -delete"; } | crontab -
