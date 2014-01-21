canadian_build
==============

This project is an implementation of building a canadian cross-compiler. However it only aims at buidling a cross-compiler which runs on windows and generates code for arm-linux while building on linux(so far it's only been tested on Ubuntu 12.04 , but i think it should work for other linux distributions as well ). 

Usage:

1. Set up the building environment. Make sure the following tools have been installed:
   autoconf \
   automake \
   autogen \
   gettext \
   gperf \
   gawk \
   gzip \
   perl \
   tcl \
   m4 \
   libtool \
   flex \
   flip \
   bison \
   texinfo \
   gcc \
   g++ \
   expect \
   dejagnu \
    
2. Download the scripts to your build directory

3. Download the required source packages which include gmp, mpfr, mpc, ppl, cloog-ppl, binutils, glibc, gcc, linux and mingw-w64. It's suggested to download the version of each package as indicated in step 4 

4. Modify the following part of build.sh to tell the exact path of the sourc code of each package downloaded in step 3.  for example:

    SRC_DIR="/path/of/source/packages/"
    
    GMP_SRC_DIR=${SRC_DIR}/gmp-5.0.2
    MPFR_SRC_DIR=${SRC_DIR}/mpfr-3.1.2
    MPC_SRC_DIR=${SRC_DIR}/mpc-1.0.1
    PPL_SRC_DIR=${SRC_DIR}/ppl-0.11.2
    CLOOG_PPL_SRC_DIR=${SRC_DIR}/cloog-ppl-0.15.11
    BINUTILS_SRC_DIR=${SRC_DIR}/binutils-2.23.1
    LINUX_SRC_DIR=${SRC_DIR}/linux-3.5.1
    LIBC_SRC_DIR=${SRC_DIR}/glibc-2.13
    GCC_SRC_DIR=${SRC_DIR}/gcc-4.6.3
    MINGW_SRC_DIR=${SRC_DIR}/mingw-w64-v2.0.7 
 
5.Open a termial, cd to build directory,  execute build.sh with command "./build.sh". Then grab a cup of coffe or something else and wait for the long building process to be over and pray there will be nothing wrong happen during building.

6. If everything goes well in step 5, the final cross-compiler (or cross compiling toolchain to be proper) will be generated right under the 'x-tool' directory after finish building. and you will find all the binary files or executable programs in the x-tool/bin/. 

7. Install the cross-compiler to Windows. Actually, it's quite easy to install the cross-compiler in a Windows machine. All you need to do is just simply copy the whole x-tools directory to any place in your Window machine(you may want to pack and compress it before copy). However i suggest that there should be no white spaces inthe name of the absolute path where you install the compiler. Notice that if there is a prompt window that reminds you that some files are already exist will pops up during installing, you can just ignore it by choosing Rename all or Replace all whichever you like. The reason of this error is that the file systems used by Windows are generally case insensitive, while there are some header files belong to linux kernel who have the same name but different case in the same directory. Since header files belong to linux are only useful in developing linux kernel modules and have no impact on user mode application development. I assume no one would develop a kernel module under Windows, so you can just ignore it. Besides that, you should keep the whole x-tools intact and DO NOT change anything inside x-tools (though you can change the name of 'x-tools' if you dislike it). Then you may want to add the full path of "xx/x-tools/bin" to the PATH evironment variable.

8.After the installation, now you are able to use the toolchain to compile programs for Raspberry pi by running the cross compiler in a command window. However you can also integrate the cross compiling toolchain into Eclipse. For more information about how to set up the Eclipse IDE, please refer to the blog from the link http://hertaville.com/2012/09/28/development-environment-raspberry-pi-cross-compiler.
