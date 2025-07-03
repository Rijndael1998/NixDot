#!/usr/bin/env bash
set -e 

cd "$(dirname "${BASH_SOURCE[0]}")"/../

pairs=(
    "master" "smol-latest"
    "master" "omen"
    "master" "work/laptop"
    "master" "server/master"
    "server/master" "server/trusty"
)

for ((i=0; i<${#pairs[@]}; i+=2)); do
    source="${pairs[i]}"
    destination="${pairs[i+1]}"
    ./scripts/merge.sh $source $destination
done
