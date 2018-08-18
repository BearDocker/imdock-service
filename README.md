imdock-service
====================================================

## What's this:

Mysql, Redis, Postgres, Mailcatcher, Mailhog, PureFtp

## How to choose the version:
 
  * if you use Docker Toolbox, You must choose Mysql (no volume), Because MariaDB can not use the mapping to mount the data
    
  * if you use Docker for windows, You must choose MariaDB (volume)

## How to and other docker-compose use the same network :

    #if you not have group network, you can create this, and other docker-compose use this network setting
    ~ $ docker network create --driver bridge imdockgroup


## How to setting PureFtp :

    #if you need use ftp manage you volume (imagine10255 is user name)
    ~ $ docker exec -it imdock-ftp bash
    imdock-ftp ~ $ pure-pw useradd imagine10255 -u ftpuser -d /home/ftpusers/imagine10255
    imdock-ftp ~ $ pure-pw mkdb

Your Client Ftp Setting [Transfer mode=Active(POST)] 主動式


## How to restore mysql :
```
$ docker exec -i imdock-mysql mysql -uroot -pP@ssw0rd {YOUR_DB_NAME} < {YOUR_BACKUP_SQL_FILE_NAME}.sql
```

`ERROR 1406 (22001) at line 73: Data too long for column 'name' at row 1` ?

--sql-mode=, Delete "STRICT_TRANS_TABLES"


## How to backup mysql :
```
# setting your mysqldump.sh (db-name, db-password, backup-path)
~ $ crontab -e
# add this 每天半夜3點半執行備份,並且保留7天
30 03 * * * sh /{your_imdock-service_path}/mysqldump.sh
```
