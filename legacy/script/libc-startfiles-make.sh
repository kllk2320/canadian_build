#!/bin/bash

LOGFILE="libc-startfiles_make.log"

BUILD=${ARG_BUILD}
HOST=${ARG_TARGET}
TARGET=${ARG_TARGET}
#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
#SYSROOT="${BUILD_TOP}/x-tools/${TARGET}/sysroot"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"

echo "Compiling libc-startfiles starts" >${LOGFILE}
make -j${CPU_NUM} -l install_root=${SYSROOT} install-bootstrap-headers=yes install-headers >>${LOGFILE} 2>&1 || { echo "Compiling libc-startfiles failed"; exit 1; }
touch ${SYSROOT}/usr/include/gnu/stubs.h
cp bits/stdio_lim.h ${SYSROOT}/usr/include/bits
echo "Compiling libc-startfiles done" >>${LOGFILE}

echo "Installing libc-startfiles starts" >${LOGFILE}
mkdir -p ${SYSROOT}/usr/lib
make -j${CPU_NUM} -l csu/subdir_lib >>${LOGFILE} 2>&1 || { echo "Installing libc-startfiles failed"; exit 1; }
cp csu/crti.o csu/crtn.o ${SYSROOT}/usr/lib
${HOST}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o ${SYSROOT}/usr/lib/libc.so
echo "Installing libc-startfiles done" >>${LOGFILE}

