#!/bin/bash

LOGFILE="mingw_make.log"

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
echo "Compiling mingw starts" >${LOGFILE}
make -j4 -l 1>>${LOGFILE} 2>&1 || { echo "Compiling mingw failed"; exit 1; }
echo "Compiling mingw done" >>${LOGFILE}

echo "Installing mingw starts" >${LOGFILE}
make -j4 -l install DESTDIR=${SYSROOT} 1>>${LOGFILE} 2>&1 || { echo "Installing mingw failed"; exit 1; }
echo "Installing mingw done" >>${LOGFILE}


