#!/bin/sh
# 移除最後一天,並且把第0天資料往後移動

      PARM1=${1};
  FROM_PATH="your_backup_from_path"
       # ex: "/home/adminuser/docker/170404-bnl-outdoor/source-code/public/ app"
       TIME="$(date +"%Y%m%d-%H%M%S")"
  BASE_NAME=bnloutdoor-storage-backup-${TIME}
 BACKUP_DIR="/home/adminuser/docker/backups/storage"


MKDIR="$(which mkdir)"
RM="$(which rm)"
MV="$(which mv)"
GZIP="$(which gzip)"
TAR="$(which tar)"


# check the directory for store backup is writeable
test ! -w ${BACKUP_DIR} && echo "Error: ${BACKUP_DIR} is un-writeable." && exit 0


# the directory for story the newest backup
test ! -d "${BACKUP_DIR}/day-0" && $MKDIR "${BACKUP_DIR}/day-0"


# tar data
$TAR zcf ${BACKUP_DIR}/day-0/${BASE_NAME}.tar.gz -C ${FROM_PATH}
#$MV ./${BASE_NAME}.tar.gz ${BACKUP_DIR}/day-0/${BASE_NAME}.tar.gz


# the directory for story the newest backup(如果要保留7天, 就是day-7)
test ! -d "${BACKUP_DIR}/day-7" && $RM -rf "${BACKUP_DIR}/day-7"


# rotate backup directory(如果要保留7天, 就是0~6)
for DAY in 6 5 4 3 2 1 0
do
    if(test -d "${BACKUP_DIR}"/day-"${DAY}")
    then
        NEXT_DAY=`expr ${DAY} + 1`
        $RM -rf "${BACKUP_DIR}"/day-"${NEXT_DAY}"
        $MV "${BACKUP_DIR}"/day-"${DAY}" "${BACKUP_DIR}"/day-"${NEXT_DAY}"
    fi
done

exit 0;
