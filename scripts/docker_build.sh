#!/bin/bash
SOURCE_DIR=`dirname ${BASH_SOURCE[0]}`
cd $SOURCE_DIR
source ./env.sh
cd ../docker

if [ "$JUPYTER_GPU" = "TRUE" ]
then
  docker build --build-arg locale="$LOCALE" --build-arg gpu="$JUPYTER_GPU" --tag $JUPYTER_GPU_IMAGE:$JUPYTER_GPU_TAG .
else
  docker build --build-arg locale="$LOCALE" --tag $JUPYTER_IMAGE:$JUPYTER_TAG .
fi
