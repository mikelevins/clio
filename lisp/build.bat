git rev-parse --short HEAD @~ > git_hash.txt
set /p GIT_HASH=<git_hash.txt


echo "*** Built clio executable for Git hash %%GIT_HASH ***"
