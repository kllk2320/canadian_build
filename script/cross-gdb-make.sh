#!/bin/bash
LOGFILE="cross-gdb_make.log"

echo "Compiling cross-gdb starts" >${LOGFILE}
make  -j${CPU_NUM} -l >>${LOGFILE} 2>&1 || { echo "[Error]:Compiling cross-gdb failed"; exit 1; }
echo "Compiling cross-gdb done">>${LOGFILE}

echo "Installing cross-gdb starts" >>${LOGFILE}
make  install >>${LOGFILE} 2>&1 || { echo "[Error]: Installing cross-gdb failed"; exit 1; }
echo "Installing cross-gdb done">>${LOGFILE}


