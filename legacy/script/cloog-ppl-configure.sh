#!/bin/bash

CLOOG_SRCDIR="${CLOOG_PPL_SRC_DIR}"
LOGFILE="cloog_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#CLOOG_SRCDIR='../../src/cloog-ppl-0.15.11'

if [ $1 = "build" ];
then
    build_for="build"
else
    build_for="host"
fi

BUILD=${ARG_BUILD}
if [ $build_for = "build" ];
then
    HOST=${ARG_BUILD}
    LIBS_DIR="libs_for_build"
else
    HOST=${ARG_HOST}
    LIBS_DIR="libs_for_host"
fi

CFLAGS='-O2 -g -pipe'
LDFLAGS=''
LIBS='-lm'

export CFLAGS
export LDFLAGS
export LIBS

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
INSTALL_PATH=${BUILDTOOLS_DIR}/${LIBS_DIR}

#where to install cloog/ppl
PREFIX=${INSTALL_PATH}

#the path of GMP installed 
GMP_PATH="${INSTALL_PATH}"

#the path of PPL installed
PPL_PATH="${INSTALL_PATH}"

CON_OPTIONS="--build=${BUILD} --host=${HOST} --prefix=${PREFIX} --with-gmp=${GMP_PATH} --with-ppl=${PPL_PATH} --with-bits=gmp --with-host-libstdcxx=-lstdc++ --disable-shared --enable-static"

#echo $CON_OPTIONS
echo "Configuring CLOOG/PPL for ${build_for} starts" >${LOGFILE}
${CLOOG_SRCDIR}/configure ${CON_OPTIONS} 1>>${LOGFILE} 2>&1  || exit 1
echo "Configuring CLOOG/PPL for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}

