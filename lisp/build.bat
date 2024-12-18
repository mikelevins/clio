git rev-parse --short HEAD > git_hash.txt
set /p GIT_HASH=<git_hash.txt
del git_hash.txt

del /q clio.exe

sbcl --dynamic-space-size 2048 --non-interactive --no-userinit --disable-debugger --load "init.lisp" --load "clio.asd" --eval "(asdf:make \"clio\" :force t :verbose t)" --quit

echo '*** Built clio executable for Git hash: %GIT_HASH% '
