#!/usr/bin/env bash
git checkout $2 && git pull && git merge --no-edit --commit $1 && git push && git checkout $1
