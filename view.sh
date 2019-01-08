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

if [ -d "$TARGET/$PROCESS" ]; then
    echo "No single file" 
else
    vi $TARGET/$PROCESS
fi
