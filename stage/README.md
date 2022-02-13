# Clio stage

The presentation process for clio. To run the stage:

1. git clone the clio repository

2. cd into the stage directory

3. run the  neutralino  updater  to fetch  the  needed resources  and
   executables:
   
      neu update

4. Execute the neutralino runner:
5. 
      neu run

5. On Linux, if the library libappindicator3 is not installed then
   running stage will fail with a message like:
   
    neutralino-linux_x64 was stopped with error code 127
   
   If you instead run `neu run --verbose`, then you'll see a slightly
   more informative message, something like:
   
    bin/neutralino-linux_x64: error while loading shared libraries: libappindicator3.so.1: cannot open shared object file: No such file or directory
   
   In that case, you need to install the libappindicator3 library. On Ubuntu 21.04 you can install it using the following command:
   
    sudo apt-get install -y libappindicator3-dev
    
   On other Linux distributions and versions you'll need to research how to find and install this library.

