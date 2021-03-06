#!/bin/sh

if [ -z "$BUCKET" ]; then
    echo "BUCKET environment variable not set, launch with -e BUCKET=my-bucket-name"
    exit 1
fi

KEY_FILE=/etc/gcsfuse/gs_service_key_file.json

if [ ! -f $KEY_FILE ]; then
   echo $KEY_FILE does not exist please launch with -v /path-to-key-file/key-file.json:$KEY_FILE
   exit 1
fi

if [[ -z "$YEAR" ]]; then
    YEAR=`date +"%Y"`

    if [ -z "$MONTH" ]; then
        MONTH=`date +"%m"`
    fi
fi

PATH_TO_SYNC=appengine.googleapis.com/request_log/$YEAR/$MONTH

SRC=gs://$BUCKET/$PATH_TO_SYNC
DST=/mnt/logfiles_incoming/$PATH_TO_SYNC

echo Syncing Logs of $YEAR.$MONTH
echo $SRC : $DST

mkdir -p $DST
gsutil -m rsync -r $SRC $DST

# gsutil will return non zero code when there is nothing to sync -> please check errors for logs
exit 0
