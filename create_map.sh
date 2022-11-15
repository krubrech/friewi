#!/bin/sh

REMOTE_FOLDER="/volume1/photo/Klaus\ GSM\ Backup/DCIM/Camera"

REMOTE_COMMAND="cd $REMOTE_FOLDER;/usr/share/applications/ExifTool/exiftool -n -g -json -timestamp -imagewidth -imageheight -composite:gpslatitude -composite:gpslongitude -composite:gpsaltitude *2022*.jpg"

echo "Going to find filenames by executing this command remotely"
echo $REMOTE_COMMAND

export SSH_ASKPASS="/usr/bin/ssh-askpass"
ssh klaus@192.168.1.173 $REMOTE_COMMAND > raw_map_data.json



