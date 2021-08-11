#!/bin/bash

mp3_path=$1
chat_id=$2
bot_id=$3
bot_key=$4

countfiles=$(find ./ -type f -size 100k -cmin -20 -name *.mp3 -print | wc -l)

if [ $countfiles -eq 0 ]
then
   curl -d -i -X GET  https://api.telegram.org/bot$bot_id:$bot_key/sendMessage \
   --data chat_id="$chat_id" \
   --data-urlencode text="Не собирается файлы mp3 с фикрофона по адресу $mp3_path
Сервер: $HOSTNAME" > /dev/null
fi


