#!/bin/sh
# mysql建議設定 max_allowed_packet = 16M

# 移除最後一天,並且把第0天資料往後移動

     PARM1=${1};

   ACCOUNT=root
  PASSWORD=P@ssw0rd
      HOST=127.0.0.1
      PORT=3306
    DBNAME=your_db_name
      TIME="$(date +"%Y%m%d-%H%M%S")"
 BASE_NAME=${DBNAME}-backup-${TIME}
BACKUP_DIR=your_backup_path  # ex: /home/adminuser/docker/backups/db


# mysql, mysqldump and some other bin's path
DOCKER="$(which docker)"
#MYSQL="$(which mysql)"
#MYSQLDUMP="$(docker exec -it imdock-mysql mysqldump)"
MKDIR="$(which mkdir)"
RM="$(which rm)"
MV="$(which mv)"
GZIP="$(which gzip)"
TAR="$(which tar)"

# create dir
$MKDIR ${BASE_NAME}


# check the directory for store backup is writeable
test ! -w ${BACKUP_DIR} && echo "Error: ${BACKUP_DIR} is un-writeable." && exit 0


# the directory for story the newest backup
test ! -d "${BACKUP_DIR}/day-0" && $MKDIR "${BACKUP_DIR}/day-0"


# backup-database
docker exec -it imdock-mysql mysqldump -u${ACCOUNT} -p${PASSWORD} -h${HOST} -P${PORT} -c -e -n \
-B ${DBNAME} | ${GZIP} > ${BACKUP_DIR}/day-0/${BASE_NAME}.sql.gz


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
