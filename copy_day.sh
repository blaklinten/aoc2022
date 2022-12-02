#!/bin/bash

[ -z "$1" ] && {
    echo "Specify which day to copy from, like so: \`copy_day.sh 04\`"
    exit 1
}

DAY_TO_COPY="day$1"
CURRENT_DAY="${PWD##*/}"

TARGET_DIR="$PWD"
SOURCE_DIR="$PWD/../$DAY_TO_COPY"

pushd "$SOURCE_DIR" >/dev/null || exit

for item in Dockerfile src/ input.txt; do
    cp -r "$item" "$TARGET_DIR"
done
 
popd >/dev/null || exit

