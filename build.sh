#!/bin/bash

MACHINE=`uname -m`
BUILD="${MACHINE}-build-linux"
#HOST="i586-mingw32msvc"
#HOST="i686-unknown-mingw32"
#HOST="x86_64-w64-mingw32"
HOST="i686-w64-mingw32"
TARGET="arm-none-linux-gnueabi"


TOP_DIR=${PWD}

#SRC_DIR=${TOP_DIR}/src
SRC_DIR="/home/snail/compilers/win_arm/src"

GMP_SRC_DIR=${SRC_DIR}/gmp-5.0.2
MPFR_SRC_DIR=${SRC_DIR}/mpfr-3.1.2
MPC_SRC_DIR=${SRC_DIR}/mpc-1.0.1
PPL_SRC_DIR=${SRC_DIR}/ppl-0.11.2
CLOOG_PPL_SRC_DIR=${SRC_DIR}/cloog-ppl-0.15.11
BINUTILS_SRC_DIR=${SRC_DIR}/binutils-2.23.1
LINUX_SRC_DIR=${SRC_DIR}/linux-3.5.1
LIBC_SRC_DIR=${SRC_DIR}/glibc-2.17
GCC_SRC_DIR=${SRC_DIR}/gcc-4.7.3
MINGW_SRC_DIR=${SRC_DIR}/mingw-w64-v2.0.8
GDB_SRC_DIR=${SRC_DIR}/gdb-7.6.2
EXPAT_SRC_DIR=${SRC_DIR}/expat-2.1.0
#MINGW_SRC_DIR=${SRC_DIR}/mingw-w64-v3.0.0

if [ ! -d "${GMP_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${GMP_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${MPFR_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${MPFR_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${MPC_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${MPC_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${PPL_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${PPL_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${CLOOG_PPL_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${CLOOG_PPL_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${BINUTILS_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${BINUTILS_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${LINUX_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${LINUX_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${LIBC_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${LIBC_SRC_DIR} doesn't exit."
   exit 1
fi
if [ ! -d "${GCC_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${GCC_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${GDB_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${GDB_SRC_DIR} doesn't exit."
   exit 1
fi

if [ ! -d "${EXPAT_SRC_DIR}" ]; then
   echo "[ERROR]: folder ${EXPAT_SRC_DIR} doesn't exit."
   exit 1
fi

export GMP_SRC_DIR
export MPFR_SRC_DIR
export MPC_SRC_DIR
export PPL_SRC_DIR
export CLOOG_PPL_SRC_DIR
export BINUTILS_SRC_DIR
export LINUX_SRC_DIR
export LIBC_SRC_DIR
export GCC_SRC_DIR
export MINGW_SRC_DIR
export GDB_SRC_DIR
export EXPAT_SRC_DIR

#get the number of cpus
CPU_NUM=`grep -c processor /proc/cpuinfo`
export CPU_NUM

build_host_toolchain="no"
build_target_toolchain="no"

if [ -z `which ${HOST}-gcc` ];
then
#   echo "[ERROR]:Cann't find cross-compile toolchain for ${HOST}"
#   exit 1
    build_host_toolchain="yes"
    if [ ! -d "${MINGW_SRC_DIR}" ]; then
       echo "[ERROR]: folder ${MINGW_SRC_DIR} doesn't exit."
       exit 1
    fi

fi

if [ -z `which ${TARGET}-gcc` ];
then
#   echo "[ERROR]:Cann't find cross-compile toolchain for ${TARGET}"
#   exit 1
    build_target_toolchain="yes"
fi

export ARG_BUILD=${BUILD}
export ARG_HOST=${HOST}
export ARG_TARGET=${TARGET}

#Establish the build directories
BUILD_DIR=${TOP_DIR}/build
BUILDTOOLS_DIR=${TOP_DIR}/buildtools

BUILDTOOLS_BIN_DIR=${BUILDTOOLS_DIR}/bin
LIBS_FOR_BUILD_DIR=${BUILDTOOLS_DIR}/libs_for_build
LIBS_FOR_HOST_DIR=${BUILDTOOLS_DIR}/libs_for_host
TOOLCHAIN_FOR_TARGET_DIR=${BUILDTOOLS_DIR}/toolchain_for_target
TOOLCHAIN_FOR_HOST_DIR=${BUILDTOOLS_DIR}/toolchain_for_host

XTOOLS_DIR=${TOP_DIR}/x-tools
SYSROOT=${XTOOLS_DIR}/${TARGET}/sysroot
DEBUG_ROOT=${XTOOLS_DIR}/${TARGET}/debug-root

rm -rf ${BUILD_DIR}
rm -rf ${BUILDTOOLS_DIR}
rm -rf ${XTOOLS_DIR}

mkdir -p ${BUILD_DIR}

mkdir -p ${BUILDTOOLS_DIR}
mkdir -p ${BUILDTOOLS_BIN_DIR}
mkdir -p ${LIBS_FOR_HOST_DIR}


if [ ${build_target_toolchain} = "yes" ];
then
    mkdir -p ${LIBS_FOR_BUILD_DIR}
    mkdir -p ${TOOLCHAIN_FOR_TARGET_DIR}
    mkdir -p ${TOOLCHAIN_FOR_TARGET_DIR}/bin
    PATH="${TOOLCHAIN_FOR_TARGET_DIR}/bin:${PATH}"
fi

if [ ${build_host_toolchain} = "yes" ];
then
    mkdir -p ${LIBS_FOR_BUILD_DIR}
    mkdir -p ${TOOLCHAIN_FOR_HOST_DIR}
    mkdir -p ${TOOLCHAIN_FOR_HOST_DIR}/bin
    PATH="${TOOLCHAIN_FOR_HOST_DIR}/bin:${PATH}"
fi

mkdir -p ${XTOOLS_DIR}
mkdir -p ${SYSROOT}
mkdir -p ${SYSROOT}/usr/include
mkdir -p ${SYSROOT}/lib
mkdir -p ${DEBUG_ROOT}
#Create wrap script for build  tools
tools='ar as gcc g++ ld nm objcopy objdump ranlib strip'

for t in $tools;
do

fp=`which $t`
echo \
'#!/bin/bash
exec '\'"$fp"\'' "${@}"'\
> "${BUILDTOOLS_BIN_DIR}/${BUILD}-$t";
chmod 755 "${BUILDTOOLS_BIN_DIR}/${BUILD}-$t";

done

PATH=${BUILDTOOLS_BIN_DIR}:${PATH}
export PATH

#create building dirs for each component
SCRIPT_DIR=${TOP_DIR}/script

#create gmp build dir
GMP_BUILD_DIR_FOR_BUILD=${BUILD_DIR}/build-gmp-for-build
GMP_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-gmp-for-host
mkdir ${GMP_BUILD_DIR_FOR_BUILD}
mkdir ${GMP_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/gmp-configure.sh ${GMP_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/gmp-make.sh ${GMP_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/gmp-configure.sh ${GMP_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/gmp-make.sh ${GMP_BUILD_DIR_FOR_HOST}

#create mpfr build dir
MPFR_BUILD_DIR_FOR_BUILD=${BUILD_DIR}/build-mpfr-for-build
MPFR_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-mpfr-for-host
mkdir ${MPFR_BUILD_DIR_FOR_BUILD}
mkdir ${MPFR_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/mpfr-configure.sh ${MPFR_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/mpfr-make.sh ${MPFR_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/mpfr-configure.sh ${MPFR_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/mpfr-make.sh ${MPFR_BUILD_DIR_FOR_HOST}

#create mpc build dir
MPC_BUILD_DIR_FOR_BUILD=${BUILD_DIR}/build-mpc-for-build
MPC_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-mpc-for-host
mkdir ${MPC_BUILD_DIR_FOR_BUILD}
mkdir ${MPC_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/mpc-configure.sh ${MPC_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/mpc-make.sh ${MPC_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/mpc-configure.sh ${MPC_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/mpc-make.sh ${MPC_BUILD_DIR_FOR_HOST}

#create ppl build dir
PPL_BUILD_DIR_FOR_BUILD=${BUILD_DIR}/build-ppl-for-build
PPL_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-ppl-for-host
mkdir ${PPL_BUILD_DIR_FOR_BUILD}
mkdir ${PPL_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/ppl-configure.sh ${PPL_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/ppl-make.sh ${PPL_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/ppl-configure.sh ${PPL_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/ppl-make.sh ${PPL_BUILD_DIR_FOR_HOST}

#create cloog-ppl build dir
CLOOG_PPL_BUILD_DIR_FOR_BUILD=${BUILD_DIR}/build-cloog-ppl-for-build
CLOOG_PPL_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-cloog-ppl-for-host
mkdir ${CLOOG_PPL_BUILD_DIR_FOR_BUILD}
mkdir ${CLOOG_PPL_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/cloog-ppl-configure.sh ${CLOOG_PPL_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/cloog-ppl-make.sh ${CLOOG_PPL_BUILD_DIR_FOR_BUILD}
cp ${SCRIPT_DIR}/cloog-ppl-configure.sh ${CLOOG_PPL_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/cloog-ppl-make.sh ${CLOOG_PPL_BUILD_DIR_FOR_HOST}

#create binutils build dir
BINUTILS_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-binutils-for-target
BINUTILS_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-binutils-for-host
BINUTILS_BUILD_DIR_FOR_FINAL=${BUILD_DIR}/build-binutils-for-final
mkdir ${BINUTILS_BUILD_DIR_FOR_TARGET}
mkdir ${BINUTILS_BUILD_DIR_FOR_HOST}
mkdir ${BINUTILS_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/binutils-configure.sh ${BINUTILS_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/binutils-make.sh ${BINUTILS_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/binutils-configure.sh ${BINUTILS_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/binutils-make.sh ${BINUTILS_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/binutils-configure.sh ${BINUTILS_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/binutils-make.sh ${BINUTILS_BUILD_DIR_FOR_FINAL}

#create mingw-header build dir
MINGW_HEADER_BUILD_DIR=${BUILD_DIR}/build-mingw-header
mkdir ${MINGW_HEADER_BUILD_DIR}
cp ${SCRIPT_DIR}/mingw-header-configure.sh ${MINGW_HEADER_BUILD_DIR}
cp ${SCRIPT_DIR}/mingw-header-make.sh ${MINGW_HEADER_BUILD_DIR}

#create mingw build dir
MINGW_BUILD_DIR=${BUILD_DIR}/build-mingw
mkdir ${MINGW_BUILD_DIR}
cp ${SCRIPT_DIR}/mingw-configure.sh ${MINGW_BUILD_DIR}
cp ${SCRIPT_DIR}/mingw-make.sh ${MINGW_BUILD_DIR}

#create kernel-header build dir
KERNEL_HEADER_BUILD_DIR=${BUILD_DIR}/build-kernel-header
mkdir ${KERNEL_HEADER_BUILD_DIR}
cp ${SCRIPT_DIR}/kernel-header-make.sh ${KERNEL_HEADER_BUILD_DIR}

#create libc-startfiles build dir
LIBC_STARTFILES_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-libc-startfiles-for-target
mkdir ${LIBC_STARTFILES_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/libc-startfiles-configure.sh ${LIBC_STARTFILES_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/libc-startfiles-make.sh ${LIBC_STARTFILES_BUILD_DIR_FOR_TARGET}

#create libc build dir
LIBC_BUILD_DIR=${BUILD_DIR}/build-libc-for-target
mkdir ${LIBC_BUILD_DIR}
cp ${SCRIPT_DIR}/libc-configure.sh ${LIBC_BUILD_DIR}
cp ${SCRIPT_DIR}/libc-make.sh ${LIBC_BUILD_DIR}

#create core-pass-1-for-target/host build dir
CORE_PASS_1_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-core-pass-1-for-target
CORE_PASS_1_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-core-pass-1-for-host
mkdir ${CORE_PASS_1_BUILD_DIR_FOR_TARGET}
mkdir ${CORE_PASS_1_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/core-pass-1-configure.sh ${CORE_PASS_1_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/core-pass-1-make.sh ${CORE_PASS_1_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/core-pass-1-configure.sh ${CORE_PASS_1_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/core-pass-1-make.sh ${CORE_PASS_1_BUILD_DIR_FOR_HOST}

#create core-pass-2-for-target/host build dir
CORE_PASS_2_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-core-pass-2-for-target
CORE_PASS_2_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-core-pass-2-for-host
mkdir ${CORE_PASS_2_BUILD_DIR_FOR_TARGET}
mkdir ${CORE_PASS_2_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/core-pass-2-configure.sh ${CORE_PASS_2_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/core-pass-2-make.sh ${CORE_PASS_2_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/core-pass-2-configure.sh ${CORE_PASS_2_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/core-pass-2-make.sh ${CORE_PASS_2_BUILD_DIR_FOR_HOST}

#create final-gcc for host build dir
FINAL_GCC_BUILD_DIR_FOR_HOST=${BUILD_DIR}/build-final-gcc-for-host
mkdir ${FINAL_GCC_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/final-gcc-configure.sh ${FINAL_GCC_BUILD_DIR_FOR_HOST}
cp ${SCRIPT_DIR}/final-gcc-make.sh ${FINAL_GCC_BUILD_DIR_FOR_HOST}

#create final-gcc for target build dir
FINAL_GCC_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-final-gcc-for-target
mkdir ${FINAL_GCC_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/final-gcc-configure.sh ${FINAL_GCC_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/final-gcc-make.sh ${FINAL_GCC_BUILD_DIR_FOR_TARGET}

#create final-gcc for final build dir
FINAL_GCC_BUILD_DIR_FOR_FINAL=${BUILD_DIR}/build-final-gcc-for-final
mkdir ${FINAL_GCC_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/final-gcc-configure.sh ${FINAL_GCC_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/final-gcc-make.sh ${FINAL_GCC_BUILD_DIR_FOR_FINAL}

#create libexpat for host build dir
LIBEXPAT_BUILD_DIR_FOR_FINAL=${BUILD_DIR}/build-libexpat-for-final
mkdir ${LIBEXPAT_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/libexpat-configure.sh ${LIBEXPAT_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/libexpat-make.sh ${LIBEXPAT_BUILD_DIR_FOR_FINAL}

#create cross-gdb for host build dir
CROSS_GDB_BUILD_DIR_FOR_FINAL=${BUILD_DIR}/build-cross-gdb-for-final
mkdir ${CROSS_GDB_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/cross-gdb-configure.sh ${CROSS_GDB_BUILD_DIR_FOR_FINAL}
cp ${SCRIPT_DIR}/cross-gdb-make.sh ${CROSS_GDB_BUILD_DIR_FOR_FINAL}

#create gdbserver for host build dir
GDBSERVER_BUILD_DIR_FOR_TARGET=${BUILD_DIR}/build-gdbserver-for-target
mkdir ${GDBSERVER_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/gdbserver-configure.sh ${GDBSERVER_BUILD_DIR_FOR_TARGET}
cp ${SCRIPT_DIR}/gdbserver-make.sh ${GDBSERVER_BUILD_DIR_FOR_TARGET}

##Start build ###
#echo $PATH
cp ${SCRIPT_DIR}/autobuild.sh ${BUILD_DIR}
cd ${BUILD_DIR}
./autobuild.sh ${build_target_toolchain} ${build_host_toolchain}
#echo ${CPU_NUM}
cd ${TOP_DIR}
