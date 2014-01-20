#!/bin/bash

LOGFILE="libc_make.log"

BUILD=${ARG_BUILD}
HOST=${ARG_TARGET}
TARGET=${ARG_TARGET}
#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"

#echo ${INSTALL_ROOT}
echo "Compiling libc starts" >${LOGFILE}
make -j4 -l all >>${LOGFILE} 2>&1 || { echo "Compiling libc failed"; exit 1; }
echo "Compiling libc done" >>${LOGFILE}
echo "Installing libc starts" >${LOGFILE}
make -j4 -l install_root=${SYSROOT} install >>${LOGFILE} 2>&1 || { echo "Installing libc failed"; exit 1; }
echo "Installing libc done" >>${LOGFILE}
