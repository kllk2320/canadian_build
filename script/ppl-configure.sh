#!/bin/bash

PPL_SRCDIR="${PPL_SRC_DIR}"
LOGFILE="ppl_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#PPL_SRCDIR='../../src/ppl-0.11.2'

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
CXXFLAGS='-O2 -g -pipe'
LDFLAGS=''

export CFLAGS
export CXXFLAGS
export LDFLAGS

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
INSTALL_PATH="${BUILDTOOLS_DIR}/${LIBS_DIR}"

#where to install PPL
PREFIX="${INSTALL_PATH}"

#the path of GMP installed 
GMP_PATH="${INSTALL_PATH}"

#configuration options
CON_OPTIONS="--build=${BUILD} --host=${HOST} --prefix=${PREFIX} --with-libgmp-prefix=${GMP_PATH} --with-libgmpxx-prefix=${GMP_PATH} --with-gmp-prefix=${GMP_PATH} --disable-shared  --enable-watchdog --disable-debugging --disable-assertions --disable-ppl_lcdd --disable-ppl_lpsol --enable-interfaces=c c++ --enable-static"

#echo $con_options
echo "Configuring PPL for ${build_for} starts" >${LOGFILE}
${PPL_SRCDIR}/configure ${CON_OPTIONS} 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring PPL for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}

