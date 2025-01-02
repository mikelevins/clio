#!/bin/sh

GIT_HASH=$(git rev-parse --short HEAD)

rm -f clio

sbcl --non-interactive \
     --no-userinit \
     --disable-debugger \
     --load "init.lisp" \
     --load "clio.asd" \
     --eval '(asdf:make "clio" :force t :verbose t)' \
     --quit

echo "*** Built clio executable for Git hash $GIT_HASH ***"
