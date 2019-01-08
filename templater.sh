#!/bin/bash
set -e

DIRECTORY=`realpath $(dirname $0)/..`
CACHE=`realpath $DIRECTORY/cache`

PROCESS=$1
partsdir=`realpath ${DIRECTORY}/src/$(dirname $PROCESS)/parts`
extension="${PROCESS##*.}"

function replace_parts() {
    IFS=$'\n'
    local srcfile=$1
    local parts=$(grep -oE '\{\{[A-Za-z0-9_&;",\.\(\)% ]+\}\}' $srcfile | sort | uniq | sed -e 's/^{{//' -e 's/}}$//')
    local part=""
    for part in $parts; do
        unset IFS
        local input=( $part )
        if [ "${#input[@]}" -lt "2" ] ; then
            continue
        fi

        local partfile="${input[1]}.${extension}"
        local md5sum=`echo $part | /usr/bin/md5sum | cut -f1 -d" "`
        local subdir=${input[0]}

        local target="$CACHE/${md5sum}_${partfile}"
        cp $partsdir/$subdir/$partfile $target

        local counter=1

        for var in ${input[@]:2} ; do
            var=${var//\//\\/}
            var=${var//&/\\&}
            sed -i -- "s/{{$counter}}/$var/g" $target 
            (( counter++ ))
        done   

        replace_parts $target

        sed -i -e "/{{$part}}/{r $target" -e 'd}' $srcfile
    done
}

function replace_variable() {
    local srcfile=$1
    local replacefile=$2

    echo "Processing $replacefile replacements"
    while IFS='' read -r line || [[ -n "$line" ]]; do
        if [ -n "$line" ]; then
            LABEL=`cut -d '=' -f 1 <<< "$line"`
            VALUE=`cut -d '=' -f 2- <<< "$line"`
            VALUE=${VALUE//\//\\/}
            VALUE=${VALUE//&/\\&}
            sed -i -- "s/\_\_$LABEL\_\_/$VALUE/g" $srcfile
        fi
    done < "$DIRECTORY/src/$replacefile"
}

rm -f $CACHE/*

replace_parts $DIRECTORY/target/$PROCESS

replace_variable $DIRECTORY/target/$PROCESS colors

sed -i "s/&nbsp;/ /g" $DIRECTORY/target/$PROCESS

rm -f $CACHE/*
