#!/usr/bin/env bash

set -e

USE_OS_RELEASE="bookworm"
BRANCH="main"
TMPFILE=$(mktemp)
for d in images/*; do
    if [ -d "$d" ]; then
        pushd "$d" > /dev/null
        img=$(basename "$d")
        curl -sSLO "https://raw.githubusercontent.com/devcontainers/images/refs/heads/$BRANCH/src/$img/manifest.json"
        latest=$(jq -r '.build.latest' manifest.json)
        jq -c '[.build.architectures | to_entries[] | select(contains({key: "'$USE_OS_RELEASE'"})) | {image: "'$img'", variant:.key, platforms: (.value | join(",")), latest: (.key == "'$latest'")}]' manifest.json >> $TMPFILE
        rm manifest.json
        popd > /dev/null
    fi
done
jq -s 'reduce.[] as $item ([];. + $item) | {include: .}' $TMPFILE > manifest.json
rm $TMPFILE
