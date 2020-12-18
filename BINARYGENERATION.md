# libnss_cache.so.2.0 BINARYGENERATION

###Requirements:

1. SSH into an ubuntu VM.
   
   **Note:** For our case we used a test VM on ubuntu 20.04 platform which we created as part of our analysis.

###Follow below mentioned steps to generate the required binary.
1. Install dependencies

   `apt install make`

2. clone the libnss-cache repository to it.

   `git clone https://github.com/google/libnss-cache.git`

3. `cd` to the cloned repo directory and if need be, edit the Make file  in  libnss-cache, to change the path where the binary will be printed to following

    `PREFIX=$(DESTDIR)/<required_path>`

4. run

   `make install`

The `libnss_cache.so.2.0` would be created at the set path in the make file.

5. Now do an `scp` to copy the binary from the remote host to the local machine.

   `scp user@<remote_host>:<path in remote host> ./libnss_cache.so.2.0_2004`



Use the above file to be added as binary in the repo.