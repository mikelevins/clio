#!/bin/sh

GIT_HASH=$(git rev-parse --short HEAD)

rm -f clio

sbcl --dynamic-space-size 2048 \
     --non-interactive \
     --no-userinit \
     --disable-debugger \
     --load "init.lisp" \
     --eval '(asdf:make "clio" :force t :verbose t)' \
     --quit

echo "*** Built clio executable for Git hash $GIT_HASH ***"
