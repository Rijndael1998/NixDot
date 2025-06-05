#!/usr/bin/env bash

set -e 

./scripts/cleanAndPull.sh
./scripts/channels.sh
./scripts/rebuild.sh

