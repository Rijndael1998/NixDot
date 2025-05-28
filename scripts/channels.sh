#!/usr/bin/env bash

set -e 

# remove channels
nix-channel --remove nixos
nix-channel --remove nixos-unstable

# stale for now...
nix-channel --add https://nixos.org/channels/nixos-25.05          nixos
nix-channel --add https://nixos.org/channels/nixos-unstable       nixos-unstable

nix-channel --update