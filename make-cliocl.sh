#!/bin/bash

sbcl --load cliocl.asd --eval "(progn (asdf:load-system :cliocl)(build-clio))"
