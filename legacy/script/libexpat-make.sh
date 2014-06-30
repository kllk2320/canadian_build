#!/bin/bash
LOGFILE="libexpat_make.log"

echo "Compiling libexpat starts" >${LOGFILE}
make  -j${CPU_NUM} -l >>${LOGFILE} 2>&1 || { echo "[Error]:Compiling libexpat failed"; exit 1; }
echo "Compiling libexpat done">>${LOGFILE}

echo "Installing libexpat starts" >>${LOGFILE}
make  install >>${LOGFILE} 2>&1 || { echo "[Error]: Installing libexpat failed"; exit 1; }
echo "Installing libexpat done">>${LOGFILE}


