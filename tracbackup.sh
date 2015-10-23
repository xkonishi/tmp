!/bin/sh

TRAC_PROJ_DIR=/trac
TRAC_PROJS="aries ariesoperation progner progneroperation"
BACKUP_DIR=/mnt/TracBackup
TODAY_DIR=`date '+%Y%m%d'`
MAX_DAY_DIR=`date -d "7 day ago" +%Y%m%d`

# mount "hotei"
/bin/mount|grep $BACKUP_DIR >/dev/null
if [ $? -ne 0 ]; then
  /bin/mount -t cifs //hotei/Public/TracBackup $BACKUP_DIR -o password=
fi

# make backup directory
if [ -a $BACKUP_DIR/$TODAY_DIR ]; then
  rm -rf $BACKUP_DIR/$TODAY_DIR >/dev/null 2>&1
fi
mkdir $BACKUP_DIR/$TODAY_DIR >/dev/null

# backup trac project
for proj in $TRAC_PROJS
do
  #echo $proj
  trac-admin $TRAC_PROJ_DIR/$proj hotcopy $BACKUP_DIR/$TODAY_DIR/$proj
done

# remove directory
for dir in `ls $BACKUP_DIR -r`
do
  #echo $dir
  if [ $dir -le $MAX_DAY_DIR ]; then
    rm -rf $BACKUP_DIR/$dir
  fi
done
