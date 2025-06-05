#!/usr/bin/env bash

set -e 

# reset the git
cd "$(dirname "${BASH_SOURCE[0]}")"/../
git reset --hard
git fetch
git pull

