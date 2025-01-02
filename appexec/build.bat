git rev-parse --short HEAD > git_hash.txt
set /p GIT_HASH=<git_hash.txt
del git_hash.txt

del /q app.exe

sbcl --dynamic-space-size 2048 --non-interactive --no-userinit --disable-debugger --load "init.lisp" --load "appexec.asd" --eval "(asdf:make \"app\" :force t :verbose t)" --quit

echo '*** Built app executable for Git hash: %GIT_HASH% '
