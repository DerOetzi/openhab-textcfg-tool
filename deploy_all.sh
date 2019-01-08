#!/bin/bash
set -e

DIRECTORY=`realpath $(dirname $0)/..`
TARGET="$DIRECTORY/target"

files=$(find "$DIRECTORY/src" -type f -printf "%P\n" | grep -v classic | grep -v parts)
files="$files icons"

service openhab2 stop

for file in $files ; do
    $DIRECTORY/tools/deploy.sh $file
done

service openhab2 start
