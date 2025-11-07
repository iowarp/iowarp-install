I want to implement a new container called iowarp. This will contain only the binaries, libraries, and executables needed to
execute iowarp. 

I want the following:
1. From iowarp-dev, we copy the binaries, libraries, and executables needed for iowarp runtime, cte, but not jarvis.
This includes the compression libraries from iowarp-deps. This does not include spack. We do not require users
to download iowarp-dev from dockerhub for this new iowarp container. iowarp-dev is used only for copying during
the building of the new container
2. The iowarp container should inherit from a small linux, and install the few needed software described above
in adition to the already-compiled iowarp-related executables and libraries. 
