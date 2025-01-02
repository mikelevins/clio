#!/bin/sh

GIT_HASH=$(git rev-parse --short HEAD)

rm -f app

sbcl --non-interactive \
     --no-userinit \
     --disable-debugger \
     --load "init.lisp" \
     --load "appexec.asd" \
     --eval '(asdf:make "app" :force t :verbose t)' \
     --quit

echo "*** Built app executable for Git hash $GIT_HASH ***"
