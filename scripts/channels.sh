#!/usr/bin/env bash

set -e 

# remove channels
nix-channel --remove nixos
nix-channel --remove nixos-unstable

# unstable seems to be more stable
nix-channel --add https://nixos.org/channels/nixos-unstable       nixos
nix-channel --add https://nixos.org/channels/nixos-unstable-small nixos-unstable


nix-channel --update