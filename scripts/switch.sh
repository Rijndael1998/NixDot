#!/usr/bin/env bash

set -e 

./scripts/cleanAndPull.sh
nixos-rebuild switch

