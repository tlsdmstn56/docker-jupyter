#!/bin/bash
SOURCE_DIR=`dirname ${BASH_SOURCE[0]}`
cd $SOURCE_DIR
source ./env.sh
cd ..
LOGS="./logs"
if [ -d $LOGS ]
then
  rm -rf $LOGS
fi

mkdir $LOGS
touch $LOGS/jupyter.log

if [ "$JUPYTER_GPU" = "TRUE" ]
then
DOCKER="nvidia-docker"
IMAGE="$JUPYTER_GPU_IMAGE"
TAG="$JUPYTER_GPU_TAG"
else
DOCKER="docker"
IMAGE="$JUPYTER_IMAGE"
TAG="$JUPYTER_TAG"
fi

$DOCKER rm -f $JUPYTER_NAME
$DOCKER run -i -t -d --name $JUPYTER_NAME \
--privileged --restart=always \
-p $JUPYTER_PORT:8888 -p $JUPYTER_RESTAPIPORT:8088 \
-v $JUPYTER_VOLUME:/root/volume \
-e JUPYTER_BASEURL=$JUPYTER_BASEURL -e JUPYTER_PASSWORD=$JUPYTER_PASSWORD \
$IMAGE:$TAG /root/volume/scripts/run_jupyter.sh