canadian_build
==============

This project is an implementation of building a canadian cross-compiler(or cross compiling toolchain). However it aims only at buidling a cross-compiler which runs on a Windows machine and generates binaries for an ARM machine running linux operating system. While the building process is undertaken on a linux machine. For this project I'm using Ubuntu 12.04 on my PC. But i think it should work on most Debian/Ubuntu based linux distributions running directly on a PC or as a guest operating system via VMWare/VirtualBox as well).


Usage of the scripts:

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
 
5. Open a termial, cd to build directory,  execute build.sh with command "./build.sh". Then you can grab a cup of coffe or something else and wait for the long building process to be over and pray there will be nothing wrong happen during building.

6. If everything goes well in step 5, the final cross compiling toolchain will be generated right under the 'x-tools' directory when it finishs building. You will find all toolchain's binary tools(gcc, as, ld, etc.) in the 'x-tools/bin/' directory. 

7. Install the cross-compiler to a Windows machine. Actually, it's quite easy to install the cross-compiler in a Windows machine. All you need to do is just simply copy the whole x-tools directory to any places in your Window machine(you may want to pack and compress it before copy). However i suggest that there should be no white spaces in the name of the absolute path where you install the toolchain. Note that if there is a prompt window that reminds you that some files are already exist pops up during installing, you can just ignore it by choosing either 'Rename all' or 'Replace all' whichever you like. The reason of this happening is that the file systems used in Windows are generally case insensitive, while there are some header files who have the same name but different case in the same directory in the package. However those header files are part of linux kernel header files which are only useful in developing linux kernel modules but not useful in developing user mode applications. I assume no one would develop kernel modules under Windows, so you can just ignore it. Besides that, you should keep the whole x-tools intact and DO NOT change anything inside x-tools (though you can change the name of 'x-tools' if you dislike it). After that you may want to add the full path of "xx/x-tools/bin" to the PATH evironment variable if you don't want to provide the full path of the toolchain's binary tools each time you use it.

8. After the installation, now you are able to use the toolchain to compile programs for Raspberry pi. You can run the toolchain's binary tools from command line via the Command window. Or you also can integrate the cross compiling toolchain into Eclipse and run it from Eclipse IDE. For more information about how to set up the Eclipse IDE, please refer to the blog from the link http://hertaville.com/2012/09/28/development-environment-raspberry-pi-cross-compiler. Note the blog is wrote for Linux, but it's similar for Windows. 
