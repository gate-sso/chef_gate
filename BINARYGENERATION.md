# libnss_cache.so.2.0 BINARYGENERATION

###Follow below mentioned steps to generate the required binary on a ubuntu machine.
1. Install dependencies

   `apt install make`

2. clone the libnss-cache repository to it.

   `git clone https://github.com/google/libnss-cache.git`

3. `cd` to the cloned repo directory and if need be, edit the Make file  in  libnss-cache, to change the path where the binary will be printed to following

    `PREFIX=$(DESTDIR)/<required_path>`

4. run

   `make install`

The `libnss_cache.so.2.0` would be created at the set path in the make file.

Use the above file to be added as binary in the repo.