#!/bin/bash

BINUTILS_SRCDIR="${BINUTILS_SRC_DIR}"
LOGFILE="binutils_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#TARGET="arm-unknown-linux-gnueabi"
#BINUTILS_SRCDIR='../../src/binutils-2.23.1'

#possible value of the parameter
# 'host'     building cross-compiler toolchain for host which runs on build
# 'target'   building cross-compiler toolchain for target which runs on build
# 'final'    building the final cross-compiler toolchain for target which runs on host
if [[ $1 = "host" || $1 = "target" ]];
then
    build_for="$1"
else 
    build_for="final"
fi

BUILD=${ARG_BUILD}
if [[ ${build_for} = "host" || ${build_for} = "target" ]];
then
    HOST=${ARG_BUILD}
else
    HOST=${ARG_HOST}
fi

if [ ${build_for} = "host" ];
then
    TARGET=${ARG_HOST}
else
    TARGET=${ARG_TARGET}
fi

CFLAGS='-O2 -g -pipe'
CXXFLAGS='-O2 -g -pipe'
LDFLAGS=''

export CFLAGS
export CXXFLAGS
export LDFLAG

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"

if [ ${build_for} = "host" ];
then
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_host"
elif [ ${build_for} = "target" ];
then
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_target"
else
    INSTALL_PATH="${XTOOLS_DIR}"
fi

#where to install binutils
PREFIX="${INSTALL_PATH}"

CON_OPTIONS_1="--build=${BUILD} --host=${HOST} --target=${TARGET} --prefix=${PREFIX} "
CON_OPTIONS_2="--with-pkgversion=Snail_Test-1.0.0 --with-sysroot=${SYSROOT} "
CON_OPTIONS_3="--enable-ld=yes --enable-gold=no "
CON_OPTIONS_4="--disable-werror --disable-multilib --disable-nls "

if [ ${build_for} != "host" ];
then
CON_OPTIONS_5="-with-float=hard"
fi

CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4} ${CON_OPTIONS_5}"
#CON_OPTIONS="--build=${BUILD} --host=${HOST} --target=${TARGET} --prefix=${PREFIX} --disable-werror --enable-ld=yes --enable-gold=no --with-pkgversion=Snail_Test-1.0.0 --disable-multilib --disable-nls -with-float=hard --with-sysroot=${SYSROOT}"

#echo $CON_OPTIONS
echo "Configuring binutils for ${build_for} starts" >${LOGFILE}
${BINUTILS_SRCDIR}/configure  ${CON_OPTIONS} 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring binutils for ${build_for}  done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}

