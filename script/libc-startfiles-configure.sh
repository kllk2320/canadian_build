#!/bin/bash

LIBC_SRCDIR="${LIBC_SRC_DIR}"
LOGFILE="libc-startfiles_config.log"

#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"
BUILD=${ARG_BUILD}
HOST=${ARG_TARGET}
TARGET=${ARG_TARGET}

BUILD_CC="${BUILD}-gcc"
CC="${HOST}-gcc"
AR="${HOST}-ar"
RANLIB="${HOST}-ranlib"
CFLAGS='-U_FORTIFY_SOURCE -mlittle-endian -mhard-float -O2 -march=armv6 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp'
LDFLAGS=''

export BUILD_CC
export CC
export AR
export RANLIB
export CFLAGS
export LDFLAGS

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}
BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"

PREFIX="/usr"

HEADERS_DIR="${SYSROOT}/usr/include"
CON_OPTIONS_1="--prefix=${PREFIX} --build=${BUILD} --host=${HOST}"
CON_OPTIONS_2="--cache-file=${PWD}/config.cache --with-headers=${HEADERS_DIR}"
CON_OPTIONS_3="--with-__thread --with-tls --with-fp --with-pkgversion=Snail_Test-1.0.0"
CON_OPTIONS_4="--without-cvs --without-gd --disable-profile --enable-obsolete-rpc --enable-kernel=3.5.1 --enable-shared --enable-add-on=nptl,ports"
#the linker installed during buiding bintils was cross-compiled and as such cannot be used until glibc has been installed, which means that the configure test for force-unwind support wil fail, as it relies on a working linker. Thus this option is passed to inform confiugre that force-unwind support is available without it having to run the test
CON_OPTIONS_5="libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes "
#CON_OPTIONS_5="--disable-debug --disable-sanity-checks "
#confiugration options
CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4} ${CON_OPTIONS_5}"

#${CC} -v
#echo ${CON_OPTIONS}
echo "Configuring libc-startfiles starts" >${LOGFILE}
${LIBC_SRCDIR}/configure $CON_OPTIONS 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring libc-startfiles done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
