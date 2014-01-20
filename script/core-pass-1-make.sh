#!/bin/bash
LOGFILE="pass-1_make.log"

echo "Compiling pass-1 core starts" >${LOGFILE}
#make -j4 all-gcc >>${LOGFILE} 
make  -j4 -l all-gcc >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling core-pass-1 failed"; exit 1; }
echo "Compiling pass-1 core done">>${LOGFILE}

echo "Installing pass-1 core starts" >>${LOGFILE}
make  -j4 -l install-gcc >>${LOGFILE}  2>&1 || { echo "[Error]: Installing core-pass-1 failed"; exit 1; }
#make  -j4 -l install-gcc >>${LOGFILE}  
echo "Installing pass-1 core done">>${LOGFILE}

