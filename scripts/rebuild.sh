#!/usr/bin/env bash

set -e 

# make the system
nix-collect-garbage --delete-older-than 30d
nixos-rebuild boot