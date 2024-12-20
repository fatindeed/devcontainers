#!/usr/bin/env bash

set -e

IGNORE_OS_RELEASE="bullseye"
BRANCH="main"
TMPFILE=$(mktemp)
for d in images/*; do
    if [ -d "$d" ]; then
        pushd "$d" > /dev/null
        img=$(basename "$d")
        curl -sSLO "https://raw.githubusercontent.com/devcontainers/images/refs/heads/$BRANCH/src/$img/manifest.json"
        latest=$(jq -r '.build.latest' manifest.json)
        jq -c '[.variants[] | select(test("'$IGNORE_OS_RELEASE'"; "n") | not) | {image: "'$img'", variant:., latest: (. == "'$latest'")}]' manifest.json >> $TMPFILE
        rm manifest.json
        popd > /dev/null
    fi
done
jq -s 'reduce.[] as $item ([];. + $item) | {include: .}' $TMPFILE > manifest.json
rm $TMPFILE
