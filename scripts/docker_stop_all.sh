#!/bin/bash
SOURCE_DIR=`dirname ${BASH_SOURCE[0]}`
cd $SOURCE_DIR
source ./env.sh
cd ..

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

$DOCKER stop $JUPYTER_NAME
