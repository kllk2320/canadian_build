#!/bin/bash

LOGFILE="mingw-header_make.log"

BUILD=${ARG_BUILD}
HOST=${ARG_HOST}
TARGET=${ARG_HOST}
#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

XTOOLS_DIR="${BUILD_TOP}/x-tools"
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
TOOLCHAIN_FOR_HOST_DIR="${BUILDTOOLS_DIR}/toolchain_for_host"
SYSROOT="${TOOLCHAIN_FOR_HOST_DIR}/${TARGET}/sysroot"

#echo ${INSTALL_ROOT}
echo "Compiling mingw header starts" >${LOGFILE}
make 1>>${LOGFILE} 2>&1 || { echo "Compiling mingw header failed"; exit 1; }
echo "Compiling mingw header done" >>${LOGFILE}

echo "Installing mingw header starts" >${LOGFILE}
make install DESTDIR=${SYSROOT} 1>>${LOGFILE} 2>&1 || { echo "Installing mingw header failed"; exit 1; }
echo "Installing mingw header done" >>${LOGFILE}

ln -s usr/${TARGET} ${SYSROOT}/mingw
#ln -s usr/ ${SYSROOT}/mingw

#
sed -i '
/<crtdefs.h>/ a\
typedef int	daddr_t;\
typedef char *	caddr_t;
' ${SYSROOT}/mingw/include/sys/types.h 
