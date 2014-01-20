#!/bin/bash

GCC_SRCDIR="${GCC_SRC_DIR}"
LOGFILE="final-gcc_config.log"

#BUILD="x86_64-build-linux"
#HOST="x86_64-build-linux"
#HOST="i586-mingw32msvc"
#TARGET="arm-unknown-linux-gnueabi"
#GCC_SRCDIR='../../src/gcc-4.7.2'

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
if [[ ${build_for} = "host" || "${build_for}" = "target" ]];
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
LDFLAGS=''
CC_FOR_BUILD="${BUILD}-gcc"

if [[ ${build_for} = "host" ]];
then

CFLAGS_FOR_TARGET="-march=x86-64"
CXXFLAGS_FOR_TARGET="-march=x86-64"
LDFLAGS_FOR_TARGET=""
else
CFLAGS_FOR_TARGET="-mlittle-endian -mhard-float -march=armv6 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp"
CXXFLAGS_FOR_TARGET="-mlittle-endian -mhard-float -march=armv6 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp"
LDFLAGS_FOR_TARGET="-Wl,-EL "

fi
export CFLAGS
export CC_FOR_BUILD
export LDFLAGS
export CFLAGS_FOR_TARGET
export CXXFLAGS_FOR_TARGET
export LDFLAGS_FOR_TARGET

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

BUILDTOOLS_DIR="${BUILD_TOP}/buildtools"
XTOOLS_DIR="${BUILD_TOP}/x-tools"
TOOLCHAIN_FOR_HOST_DIR="${BUILDTOOLS_DIR}/toolchain_for_host"
TOOLCHAIN_FOR_TARGET_DIR="${BUILDTOOLS_DIR}/toolchain_for_target"

if [ "${build_for}" = "host" ];
then
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_host"
    LIBS_PATH="${BUILDTOOLS_DIR}/libs_for_build"
    SYSROOT="${TOOLCHAIN_FOR_HOST_DIR}/${TARGET}/sysroot"
elif [ "${build_for}" = "target" ];
then
    INSTALL_PATH="${BUILDTOOLS_DIR}/toolchain_for_target"
    LIBS_PATH="${BUILDTOOLS_DIR}/libs_for_build"
    SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"
else
    INSTALL_PATH="${XTOOLS_DIR}"
    LIBS_PATH="${BUILDTOOLS_DIR}/libs_for_host"
    SYSROOT="${XTOOLS_DIR}/${TARGET}/sysroot"
fi

#where to install final gcc 
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
CON_OPTIONS_4="--with-pkgversion=Snail_Test-1.0.0 "
CON_OPTIONS_5="--enable-shared --enable-__cxa_atexit --enable-c99 --enable-long-long --enable-target-optspace --enable-languages=c,c++ "
CON_OPTIONS_6="--disable-libgomp --disable-libmudflap --disable-nls --disable-multilib --disable-libssp "
#CON_OPTIONS_6="--with-host-libstdcxx=-Wl,-Bstatic,-lstdc++,-Bdynamic -lm"
#CON_OPTIONS_6="--with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_PATH}/lib -lpwl'"
if [[ $build_for = "host" ]];
then

if [[ ${TARGET:0:1} = "i" ]];
then
CON_OPTIONS_7="--with-arch=${TARGET%%-*} --with-threads=win32 "
else
CON_OPTIONS_7="--with-arch=x86-64 --with-threads=win32 "
fi

else

CON_OPTIONS_7="--enable-threads=posix --with-float=hard --with-arch=armv6 --with-cpu=arm1176jzf-s --with-tune=arm1176jzf-s --with-fpu=vfp --disable-libquadmath --disable-libquadmath-support "

fi


CON_OPTIONS="${CON_OPTIONS_1} ${CON_OPTIONS_2} ${CON_OPTIONS_3} ${CON_OPTIONS_4} ${CON_OPTIONS_5} ${CON_OPTIONS_6} ${CON_OPTIONS_7}"

echo "Configuring final gcc for ${build_for} starts" >${LOGFILE}
#cp -a ${SYSROOT}/usr/include ${PREFIX}/${TARGET}/include 
${GCC_SRCDIR}/configure ${CON_OPTIONS} --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_PATH}/lib -lpwl" 1>>${LOGFILE} 2>&1 || exit 1
echo "Configuring final gcc for ${build_for} done" >>${LOGFILE}
echo "===========================================================================" >>${LOGFILE}
