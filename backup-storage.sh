#!/bin/sh
# 移除最後一天,並且把第0天資料往後移動

PARM1=${1};
 TIME="$(date +"%Y%m%d-%H%M%S")"
 
 
 #===================BACKUP-Info===================
  BACKUP_FROM_DIR="your_backup_from_path" # ex: "/home/adminuser/docker/website/source-code/public/ app" 注意空格
 BACKUP_SAVE_NAME=yourwebsite-storage-backup-${TIME}
    BACKUP_TO_DIR="your_backup_path"  # ex: /home/adminuser/Dropbox/backups/storage


MKDIR="$(which mkdir)"
RM="$(which rm)"
MV="$(which mv)"
GZIP="$(which gzip)"
TAR="$(which tar)"


# check the directory for store backup is writeable
test ! -w ${BACKUP_TO_DIR} && echo "Error: ${BACKUP_TO_DIR} is un-writeable." && exit 0


# the directory for story the newest backup
test ! -d "${BACKUP_TO_DIR}/day-0" && $MKDIR "${BACKUP_TO_DIR}/day-0"


# tar data
$TAR zcf ${BACKUP_TO_DIR}/day-0/${BACKUP_SAVE_NAME}.tar.gz -C ${BACKUP_FROM_DIR}


# the directory for story the newest backup(如果要保留7天, 就是day-7)
test ! -d "${BACKUP_TO_DIR}/day-7" && $RM -rf "${BACKUP_TO_DIR}/day-7"


# rotate backup directory(如果要保留7天, 就是0~6)
for DAY in 6 5 4 3 2 1 0
do
    if(test -d "${BACKUP_TO_DIR}"/day-"${DAY}")
    then
        NEXT_DAY=`expr ${DAY} + 1`
        $RM -rf "${BACKUP_TO_DIR}"/day-"${NEXT_DAY}"
        $MV "${BACKUP_TO_DIR}"/day-"${DAY}" "${BACKUP_TO_DIR}"/day-"${NEXT_DAY}"
    fi
done

exit 0;
