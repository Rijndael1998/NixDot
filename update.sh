#!/usr/bin/env bash

# unfuck the bash
set -e 

# unfuck the git
git reset --hard
git fetch
git pull

# unfuck the channels
nix-channel --remove nixos
nix-channel --remove nixos-unstable

# stale for now...
nix-channel --add https://nixos.org/channels/nixos-24.11 nixos
nix-channel --add https://nixos.org/channels/nixos-unstable-small nixos-unstable

nix-channel --update

# make the system
nixos-rebuild boot