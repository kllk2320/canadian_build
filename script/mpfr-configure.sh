#!/bin/bash

MPFR_SRCDIR="${MPFR_SRC_DIR}"
LOGFILE="mpfr_config.log"

#BUILD="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#HOST="x86_64-build-linux"
#MPFR_SRCDIR='../../src/mpfr-3.1.2'

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

CC="${HOST}-gcc"
CFLAGS='-O2 -g -pipe'
LDFLAGS=''

export CC
export CFLAGS
export LDFLAGS

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
INSTALL_PATH="${BUILDTOOLS_DIR}/${LIBS_DIR}"

#where to install mpfr
PREFIX="${INSTALL_PATH}"

#the path of GMP installed 
GMP_PATH="${INSTALL_PATH}"

#configuration options
con_options="--build=${BUILD} --host=${HOST} --prefix=${PREFIX} --with-gmp=${GMP_PATH} --disable-shared --enable-static"

#echo $con_options
echo "Configuring MPFR for ${build_for} starts" >${LOGFILE}
${MPFR_SRCDIR}/configure $con_options 1>>${LOGFILE} 2>&1  || exit 1
echo "Configuring MPFR for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}

