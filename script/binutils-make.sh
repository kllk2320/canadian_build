#!/bin/bash
LOGFILE="binutils_make.log"

#TARGET="arm-unknown-linux-gnueabi"
#
##where to install binutils
#PREFIX="/home/snail/compilers/test/x-tools"
#SYSROOT="${PREFIX}/${TARGET}/sysroot"
#BUILDTOOL="/home/snail/compilers/test/buildtools"
#

echo "Compiling binutils starts" >${LOGFILE}
make -j4 -l >>${LOGFILE} 2>&1 || { echo "Compiling binutils failed"; exit 1; }
#make -j4 -l >>${LOGFILE} 
echo "Compiling binutils done">>${LOGFILE}

echo "Installing binutils starts" >>${LOGFILE}
make -j4 install >>${LOGFILE} 2>&1 || { echo "Installing binutils failed"; exit 1; }
echo "Installing binutils done">>${LOGFILE}

#tools="ar as ld strip ld.bfd"
#for t in ${tools};
#do
#    ln -sv ${PREFIX}/bin/${TARGET}-$t ${BUILDTOOL}/bin/${TARGET}-$t >>${LOGFILE}
#done
#

