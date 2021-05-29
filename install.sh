cp ./services/rtspcollector\@.service  /etc/systemd/system/
mkdir -p /usr/local/share/rtsp_collector/
cp ./src/record_files.sh /usr/local/share/rtsp_collector/
cp ./src/convert_alaw_to_mp3.sh /usr/local/share/rtsp_collector/
chmod 755 /usr/local/share/rtsp_collector/record_files.sh
chmod 755 /usr/local/share/rtsp_collector/convert_alaw_to_mp3.sh
