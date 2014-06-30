#!/bin/bash

GDBSERVER_SRCDIR="${GDB_SRC_DIR}/gdb/gdbserver"
LOGFILE="gdbserver_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#TARGET="arm-unknown-linux-gnueabi"
BUILD=${ARG_BUILD}
HOST=${ARG_TARGET}
TARGET=${ARG_TARGET}

CFLAGS='-O2 -g'
LDFLAGS='-static'

export CFLAGS
export LDFLAGS


BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"

#where to install gdbserver 
PREFIX="/usr"

CON_OPTIONS_1="--build=${BUILD} --host=${HOST} --target=${TARGET}"
CON_OPTIONS_2="--prefix=${PREFIX} "
CON_OPTIONS_3="--with-pkgversion=Snail_Test-1.0.0 "
CON_OPTIONS_4="--program-prefix="

CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4}"

echo "Configuring gdbserver for ${build_for} starts" >${LOGFILE}
${GDBSERVER_SRCDIR}/configure ${CON_OPTIONS} 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring gdbserver for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
