#!/bin/bash

nameservice=$1

cd /var/spool/micropones/$nameservice

openRTSP 

filename=blabla
sox -r 16k -t al -c 1 $file /tmp/$file.wav
lame /tmp/mega_10.wav 




