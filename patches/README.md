This directory contains information about the two patches manually applied to CodeWeavers' Open Source CrossOver

* `distversion.h` - place inside `sources/wine/include`
* `build.patch` - place outside of `sources` folder, `cd` into the `sources` folder and run `patch -p1 < ../build.patch`
* To tar zip the sources folder, run `tar -jcvf TAR_NAME.tar.bz2 SOURCE_FOLDER`