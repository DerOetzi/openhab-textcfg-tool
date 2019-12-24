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
    if [[ "$PROCESS" == "automation"* ]]; then
        DEPLOY_TARGET=${PROCESS/automation/automation\/jsr223\/python\/personal}
        cp -v $TARGET/$PROCESS /swarm/etc/openhab/$DEPLOY_TARGET
    else
        cp -v $TARGET/$PROCESS /swarm/etc/openhab/$PROCESS
    fi
fi
