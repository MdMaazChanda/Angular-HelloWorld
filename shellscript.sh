#!/bin/bash

GIT_REPO="https://github.com/MdMaazChanda/Angular-HelloWorld.git"
ANG_DIR="/angular/"
DOCK_USERNAME="maaz0816"
DOCK_PASSWD="Nuseba@08"
DOCK_REPO="https://hub.docker.com/repository/docker/maaz0816/buildserver/general"
WEB_SERVER_IP="13.235.16.228"
CONTAINER_NAME="angular"


if [ -f tag.txt ]; then
    TAG=$(cat tag.txt)
else
    TAG=1
fi

TAG=$((TAG + 1))
echo "TAG: $TAG"
echo "$TAG" >> /containers_tags/tag.txt


if [ -z "$(ls -A $ANG_DIR)" ]; then  

        git clone $GIT_REPO $ANG_DIR
        docker build -t maaz0816/buildserver:v$TAG /angular/
        docker push maaz0816/buildserver:v$TAG
        docker login --username $DOCKER_USERNAME --password $DOCKER_PASSWD
        ssh root@$WEB_SERVER_IP
        cd /angular/
        docker image pull maaz0816/buildserver:v$TAG
  
        if [[ docker container ls -a | awk '{print $NF}' == "$CONTAINER_NAME" ]]; then
                docker stop $CONTAINER_NAME >> /containers_tags/stop_containers.txt
                docker rm $CONTAINER_NAME >> /containers_tags/removed_containers.txt
        else
                docker image pull maaz0816/buildserver:v$TAG
        fi

        docker run -itd --name $CONTAINER_NAME -p81:80 maaz0816/buildserver:v$TAG

else  
        cd $ANG_DIR
        git pull
        docker build -t maaz0816/buildserver:v$TAG /angular/
        docker push maaz0816/buildserver:v$TAG
        docker login --username $DOCK_USERNAME --password $DOCK_PASSWD
        ssh root@$WEB_SERVER_IP
        cd /angular/
        docker image pull maaz0816/buildserver:v$TAG
  
        if [[ docker container ls -a | awk '{print $NF}' == "$CONTAINER_NAME" ]]; then
                docker stop $CONTAINER_NAME >> /containers_tags/stop_containers.txt
                docker rm $CONTAINER_NAME >> /containers_tags/removed_containers.txt
        else
                docker image pull maaz0816/buildserver:v$TAG
        fi

        docker run -itd --name $CONTAINER_NAME -p81:80 maaz0816/buildserver:v$TAG
fi
