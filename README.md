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

    #maybe run this
    imdock-ftp ~ $ /usr/sbin/pure-ftpd -c 100 -C 100 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30209 &

Your Client Ftp Setting [Transfer mode=Active(POST)] 主動式