#!/bin/bash

MINGW_SRCDIR="${MINGW_SRC_DIR}/mingw-w64-headers"
LOGFILE="mingw-header_config.log"

#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"
BUILD=${ARG_BUILD}
HOST=${ARG_HOST}
TARGET=${ARG_HOST}


BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
TOOLCHAIN_FOR_HOST_DIR="${BUILDTOOLS_DIR}/toolchain_for_target"

XTOOLS_DIR="${BUILD_TOP}/x-tools"

PREFIX="/usr"

CON_OPTIONS_1="--prefix=${PREFIX} --build=${BUILD} --host=${HOST}"
CON_OPTIONS_2="--enable-sdk=all"

#confiugration options
CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} "

#${CC} -v
#echo ${CON_OPTIONS}
echo "Configuring mingw headers starts" >${LOGFILE}
${MINGW_SRCDIR}/configure $CON_OPTIONS 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring mingw headers done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
