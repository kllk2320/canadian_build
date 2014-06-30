#!/bin/bash

GMP_SRCDIR="${GMP_SRC_DIR}"
LOGFILE="gmp_config.log"

#BUILD="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#HOST="x86_64-build-linux"
#GMP_SRCDIR='../../src/gmp-5.0.2'

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

export CFLAGS
export LDFLAGS

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
INSTALL_PATH="${BUILDTOOLS_DIR}/${LIBS_DIR}"

#where to install GMP
PREFIX="${INSTALL_PATH}"

#configuration options
con_options="--build=${BUILD} --host=${HOST} --prefix=${PREFIX} --enable-fft --enable-mpbsd --enable-cxx --disable-shared --enable-static"
#begin to configure GMP
echo "Configuring GMP for ${build_for} starting" >${LOGFILE}
${GMP_SRCDIR}/configure $con_options 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring GMP for ${build_for} done"  >>${LOGFILE}
echo "=====================================================================" >>${LOGFILE}
