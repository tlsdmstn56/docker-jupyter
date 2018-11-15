#!/bin/bash
SOURCE_DIR=`dirname ${BASH_SOURCE[0]}`
cd $SOURCE_DIR
source ./env.sh
cd ..

NAME="jupyter-shell"

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

CHECK_CONTAINER="$(docker ps --all --quiet --filter=name="$NAME")"
if [ -n "$CHECK_CONTAINER" ]; then
  echo "$NAME is running, stopping and deleting"
  docker rm -f $NAME
fi
$DOCKER run -i -t --name $NAME -v $JUPYTER_VOLUME:/root/volume $IMAGE:$TAG /bin/bash
