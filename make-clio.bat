call neu build
sbcl --load cliocl.asd --eval "(progn (asdf:load-system :cliocl)(build-clio))"
move cliocl.exe dist\clio
