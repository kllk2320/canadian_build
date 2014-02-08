#!/bin/bash

#EXPAT_SRC_DIR="/home/snail/compilers/win_arm/src/expat-2.1.0"
EXPAT_SRCDIR="${EXPAT_SRC_DIR}"
LOGFILE="libexpat_config.log"

#ARG_BUILD="x86_64-build-linux"
#ARG_HOST="i586-mingw32msvc"
#ARG_TARGET="arm-none-linux-gnueabi"
BUILD=${ARG_BUILD}
HOST=${ARG_HOST}
#TARGET=${ARG_TARGET}

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
LIBS_FOR_HOST="${BUILDTOOLS_DIR}/libs_for_host"

#where to install libexpat 
PREFIX="${LIBS_FOR_HOST}"

CON_OPTIONS_1="--build=${BUILD} --host=${HOST}"
CON_OPTIONS_2="--prefix=${PREFIX}"
CON_OPTIONS_3="--disable-shared --enable-static"

CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3}"

echo "Configuring libexpat for ${build_for} starts" >${LOGFILE}
${EXPAT_SRCDIR}/configure ${CON_OPTIONS} 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring libexpat for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
