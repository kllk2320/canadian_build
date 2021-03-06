#!/bin/bash

GCC_SRCDIR="${GCC_SRC_DIR}"
LOGFILE="core-pass-1_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#TARGET="arm-unknown-linux-gnueabi"
#GCC_SRCDIR='../../src/gcc-4.6.3'

#possible value of the parameter
# 'host'     building cross-compiler toolchain for host which runs on build
# 'target'   building cross-compiler toolchain for target which runs on build
build_for=$1

BUILD=${ARG_BUILD}
HOST=${ARG_BUILD}
if [ ${build_for} = "host" ];
then
    TARGET=${ARG_HOST}
else
    TARGET=${ARG_TARGET}
fi

CFLAGS='-O2 -g -pipe'
LDFLAGS=''
CC_FOR_BUILD="${HOST}-gcc"

export CFLAGS
export CXXFLAGS
export CC_FOR_BUILD

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"
LIBS_PATH="${BUILDTOOLS_DIR}/libs_for_build"

if [ ${build_for} = "host" ];
then
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_host"
else
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_target"
fi

#where to install core pass 1
PREFIX="${INSTALL_PATH}"

LOCAL_PREFIX="${SYSROOT}"
SYSROOT="${SYSROOT}"

GMP_PATH=${LIBS_PATH}
MPC_PATH=${LIBS_PATH}
MPFR_PATH=${LIBS_PATH}
PPL_PATH=${LIBS_PATH}
CLOOG_PATH=${LIBS_PATH}
LIBELF_PATH=${LIBS_PATH}

CON_OPTIONS_1="--build=${BUILD} --host=${HOST} --target=${TARGET}"
CON_OPTIONS_2="--prefix=${PREFIX} --with-local-prefix=${LOCAL_PREFIX} --with-sysroot=${SYSROOT}"
CON_OPTIONS_3="--with-gmp=${GMP_PATH} --with-mpfr=${MPFR_PATH} --with-mpc=${MPC_PATH} --with-ppl=${PPL_PATH} --with-cloog=${CLOOG_PATH} "
CON_OPTIONS_4="--with-pkgversion=Snail_Test-1.0.0 --with-float=hard"
CON_OPTIONS_5="--enable-threads=no --disable-shared --enable-__cxa_atexit --enable-lto --enable-target-optspace --disable-libgomp --disable-libmudflap --disable-nls --disable-multilib --enable-languages=c"
CON_OPTIONS_6="--with-arch=armv6 --with-cpu=arm1176jzf-s --with-tune=arm1176jzf-s --with-fpu=vfp"
#CON_OPTIONS_6="--with-host-libstdcxx=-Wl,-Bstatic,-lstdc++,-Bdynamic -lm"
#CON_OPTIONS_6="--with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${BUILDTOOLSS_PATH}/lib -lpwl'"
CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4} ${CON_OPTIONS_5} ${CON_OPTIONS_6}"

#echo "${CON_OPTIONS}"
echo "Configuring core-pass-1 for ${build_for} starts" >${LOGFILE}
${GCC_SRCDIR}/configure ${CON_OPTIONS} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_PATH}/lib -lpwl" 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring core-pass-1 for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
