#!/bin/bash
BUILD=${ARG_BUILD}
HOST=${ARG_HOST}
TARGET=${ARG_TARGET}
LOGFILE="kernel-header_build.log"
#KERNEL_SRCDIR="../../src/linux-3.5.1"
KERNEL_SRCDIR="${LINUX_SRC_DIR}"

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

#store output files in current directory
OUTPUT_DIR=${PWD}
INSTALL_PATH="${BUILD_TOP}/x-tools/${TARGET}/sysroot/usr"

echo "Installing kernel headers starting" >>${LOGFILE}
make -C ${KERNEL_SRCDIR} O=${OUTPUT_DIR} ARCH=arm INSTALL_HDR_PATH=${INSTALL_PATH} V=0 headers_install >>${LOGFILE} 2>&1 || exit 1
echo "Installing kernel headers done">>${LOGFILE}

echo "Checking kernel headers starting" >>${LOGFILE}
make -C ${KERNEL_SRCDIR} O=${OUTPUT_DIR} ARCH=arm INSTALL_HDR_PATH=${INSTALL_PATH} V=0 headers_check >>${LOGFILE} 2>&1 || exit 1
echo "Checking kernel headers done">>${LOGFILE}
