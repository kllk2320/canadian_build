#!/bin/bash

CROSS_GDB_SRCDIR="${GDB_SRC_DIR}"
LOGFILE="cross-gdb_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#TARGET="arm-unknown-linux-gnueabi"
BUILD=${ARG_BUILD}
HOST=${ARG_HOST}
TARGET=${ARG_TARGET}

CFLAGS='-O2 -g'
LDFLAGS='-static'

export CFLAGS
export LDFLAGS


BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"

#where to install cross-gdb 
PREFIX="${XTOOLS_DIR}"

LIBEXPAT_DIR="${BUILDTOOLS_DIR}/libs_for_host"

CON_OPTIONS_1="--build=${BUILD} --host=${HOST} --target=${TARGET}"
CON_OPTIONS_2="--prefix=${PREFIX} --with-build-sysroot=${SYSROOT} --with-sysroot=${SYSROOT}"
CON_OPTIONS_3="--with-pkgversion=Snail_Test-1.0.0 "
CON_OPTIONS_4="--disable-werror --enable-threads --with-python=no --disable-sim --disable-nls"
CON_OPTIONS_3="--with-expat=yes --with-libexpat-prefix=${LIBEXPAT_DIR} "

CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4}"

echo "Configuring cross-gdb for ${build_for} starts" >${LOGFILE}
${CROSS_GDB_SRCDIR}/configure ${CON_OPTIONS} 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring cross-gdb for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
