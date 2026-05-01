#!/usr/bin/env bash

export BASENAME=$(basename $PWD)
export REPO="git@192.168.1.7"
ssh $REPO "mkdir -p $BASENAME; cd ./$BASENAME; git init -bare" && git remote add origin $REPO:/home/git/$BASENAME
git push origin master
