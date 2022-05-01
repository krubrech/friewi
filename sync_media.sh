#!/bin/sh

ALBUM_ID=4  # verse kiwis

SQL="SELECT filename FROM many_item_has_many_normal_album LEFT JOIN item  ON many_item_has_many_normal_album.id_item = item.id LEFT JOIN unit ON unit.id_item = item.id WHERE id_normal_album = $ALBUM_ID;"

PSQL_COMMAND="psql -d synofoto -t -c \"$SQL\""

REMOTE_COMMAND="sudo -Su postgres $PSQL_COMMAND"

echo "Going to find filenames by executing this command remotely"
echo $REMOTE_COMMAND

export SSH_ASKPASS="/usr/bin/ssh-askpass"
FILENAMES=$(ssh klaus@192.168.1.173 $REMOTE_COMMAND)

echo "These are the filenames to be synced"

echo $FILENAMES

$DOWNLOAD_URI="https://192.168.1.173:5001/mo/sharing/webapi/entry.cgi/"

for FILE in $FILENAMES
do
  echo "Checking File: $FILE"
  EXPANDED_FILE="/home/klaus/personal/versekiwis/source/images/uploads/$FILE"
  if test -f "$EXPANDED_FILE"; then
    echo "$EXPANDED_FILE Already exists."
  else
  echo "Downloaded File: $FILE"
    wget "$DOWNLOAD_URI$FILE" -o $EXPANDED_FILE
  fi
done

# for each file not in the repo download it to the repo


