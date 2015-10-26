#!/bin/sh

TRAC_DIR=/trac
TRAC_PJ_NAME="aries ariesoperation progner progneroperation"

MT_DIR=$HOME/backup
TODAY=`date '+%Y%m%d'`
MAX_DAY_DIR=`date -d "7 day ago" +%Y%m%d`

# create mount directory
if [ ! -e $MT_DIR ]; then
  mkdir $MT_DIR
fi

# mount "hotei"
mount|grep $MT_DIR >/dev/null
if [ $? -ne 0 ]; then
  sudo mount -t cifs -o username=prognerex,password=zaq12wsx //hotei/Public/TracBackup $MT_DIR
  if [ $? -ne 0 ]; then
    echo mount error!!
    exit 1
  fi
fi

# check backup directory
if [ -e $MT_DIR/$TODAY ]; then
  sudo rm -rf $MT_DIR/$TODAY
fi

# backup trac project
for proj in $TRAC_PJ_NAME
do
  sudo trac-admin $TRAC_DIR/$proj hotcopy $MT_DIR/$TODAY/$proj
done

# remove directory
for dir in `ls $MT_DIR -r`
do
  if [ $dir -le $MAX_DAY_DIR ]; then
    sudo rm -rf $MT_DIR/$dir
  fi
done

# umount "hotei"
sudo umount $MT_DIR
