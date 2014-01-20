#!/bin/bash

LOGFILE="mpc_config.log"
MPC_SRCDIR="${MPC_SRC_DIR}"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"

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

#where to install mpc
PREFIX=${INSTALL_PATH}

#the path of GMP installed 
GMP_PATH="${INSTALL_PATH}"

#the path of MPFR installed 
MPFR_PATH="${INSTALL_PATH}"

#confiugration options
con_options="--build=${BUILD} --host=${HOST} --prefix=${PREFIX} --with-gmp=${GMP_PATH} --with-mpfr=${MPFR_PATH} --disable-shared --enable-static"

echo "Configuring MPC for ${build_for} starts" >${LOGFILE}
${MPC_SRCDIR}/configure $con_options 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring MPC for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
