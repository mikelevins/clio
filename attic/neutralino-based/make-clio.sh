#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

neu build
sbcl --load cliocl.asd --eval "(progn (asdf:load-system :cliocl)(build-clio))"
mv cliocl dist/clio/cliocl
