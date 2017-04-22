#!/bin/bash

docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}"
read -p "Container-Name/Id: " CONTAINERID
case $CONTAINERID in
     *)
        docker exec -it ${CONTAINERID} bash
    ;;esac