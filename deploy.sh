#!/bin/bash
set -e

DIRECTORY=`realpath $(dirname $0)/..`
TARGET="$DIRECTORY/target"

if [ -z "$1" ]; then
    echo Missing argument
    exit
fi

PROCESS=$1

$DIRECTORY/tools/build.sh $PROCESS

echo Copy files to /swarm/etc/openhab/$PROCESS
if [ -d "$TARGET/$PROCESS" ]; then
    cp -r -v $TARGET/$PROCESS /swarm/etc/openhab/
else
    cp -v $TARGET/$PROCESS /swarm/etc/openhab/$PROCESS
fi
