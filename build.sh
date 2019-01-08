#!/bin/bash

set -e

DIRECTORY=`realpath $(dirname $0)/..`
SRC=`realpath $DIRECTORY/src`
TARGET=`realpath $DIRECTORY/target`

if [ -z "$1" ]; then
    echo Missing argument
    exit;
fi

PROCESS=$1
if [ "$PROCESS" == "icons" ]; then
    echo Clean $TARGET/$PROCESS
    rm -rf $TARGET/$PROCESS
    mkdir -p $TARGET/$PROCESS
    echo Copy Files to $TARGET/$PROCESS
    cp -r -L -v $SRC/$PROCESS/* $TARGET/$PROCESS/

    for i in $TARGET/icons/classic/*.svg; do
        echo "Processing templater" $(basename $i)
        $DIRECTORY/tools/templater.sh icons/classic/$(basename $i)

        echo "Converting $i"
        rsvg-convert $i -w 64 -h 64 -o `echo $i | sed -e 's/svg$/png/'`; 
    done
elif [ -f "$SRC/$PROCESS" ] ; then
    echo Clean $TARGET/$PROCESS
    rm -f $TARGET/$PROCESS
    echo Copy File to $TARGET/$PROCESS
    cp $SRC/$PROCESS $TARGET/$PROCESS
    
    echo Processing templater
    $DIRECTORY/tools/templater.sh $PROCESS

    if [ "$2" != "nosecret" ] ; then
        echo "Processing secret replacements"
        while IFS='' read -r line || [[ -n "$line" ]]; do
            if [ -n "$line" ]; then
                LABEL=`cut -d '=' -f 1 <<< "$line"`
                SECRET=`cut -d '=' -f 2- <<< "$line"`
                SECRET=${SECRET//\//\\/}
                SECRET=${SECRET//&/\\&}
                sed -i -- "s/\_\_$LABEL\_\_/$SECRET/g" $TARGET/$PROCESS
            fi
        done < "$DIRECTORY/.secret"
    fi

else
    echo "No such file"
fi
