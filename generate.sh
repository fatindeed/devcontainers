#!/usr/bin/env bash

set -e

# GH_HOST="gh-proxy.com/github.com" ./generate.sh
GH_HOST=${GH_HOST:-"github.com"}
OS_RELEASE=${OS_RELEASE:-"bookworm"}
BRANCH=${BRANCH:-"main"}
TMPFILE=$(mktemp)
for d in images/*; do
    if [ -d "$d" ]; then
        pushd "$d" > /dev/null
        img=$(basename "$d")
        curl -fsSLO "https://$GH_HOST/devcontainers/images/raw/$BRANCH/src/$img/manifest.json"
        latest=$(jq -r '.build.latest' manifest.json)
        jq -c '[.build.architectures | to_entries[] | select(contains({key: "'$OS_RELEASE'"})) | {image: "'$img'", variant:.key, platforms: (.value | join(",")), latest: (.key == "'$latest'")}]' manifest.json >> $TMPFILE
        rm manifest.json
        popd > /dev/null
    fi
done
jq -s 'reduce.[] as $item ([];. + $item) | {include: .}' $TMPFILE > manifest.json
rm $TMPFILE
