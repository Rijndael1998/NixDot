#!/usr/bin/env bash

set -e 

# remove channels
nix-channel --remove nixos
nix-channel --remove nixos-unstable
nix-channel --remove musnix

# unstable seems to be more stable
nix-channel --add https://nixos.org/channels/nixos-25.05                  nixos
nix-channel --add https://nixos.org/channels/nixos-unstable               nixos-unstable
nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz  musnix

nix-channel --update