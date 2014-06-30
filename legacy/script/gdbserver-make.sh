#!/bin/bash
LOGFILE="gdbserver_make.log"

BUILD=${ARG_BUILD}
HOST=${ARG_TARGET}
TARGET=${ARG_TARGET}
#BUILD="x86_64-build-linux"
#HOST="arm-unknown-linux-gnueabi"
#TARGET="arm-unknown-linux-gnueabi"

BUILD_PATH=`dirname ${PWD}`
BUILD_TOP=${BUILD_PATH%/*}

XTOOLS_DIR="${BUILD_TOP}/x-tools"
DEBUGROOT="${XTOOLS_DIR}/${TARGET}/debug-root"


echo "Compiling gdbserver starts" >${LOGFILE}
make  -j${CPU_NUM} -l >>${LOGFILE} 2>&1 || { echo "[Error]:Compiling gdbserver failed"; exit 1; }
echo "Compiling gdbserver done">>${LOGFILE}

echo "Installing gdbserver starts" >>${LOGFILE}
make DESTDIR=${DEBUGROOT} install >>${LOGFILE} 2>&1 || { echo "[Error]: Installing gdbserver failed"; exit 1; }
echo "Installing gdbserver done">>${LOGFILE}


