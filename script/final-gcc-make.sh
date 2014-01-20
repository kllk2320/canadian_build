#!/bin/bash
LOGFILE="final-gcc_make.log"

echo "Compiling final-gcc starts" >${LOGFILE}
make  -j4 -l all >>${LOGFILE} 2>&1 || { echo "[Error]:Compiling final-gcc failed"; exit 1; }
echo "Compiling final-gcc done">>${LOGFILE}

echo "Installing final-gcc starts" >>${LOGFILE}
make  -j4 -l install >>${LOGFILE} 2>&1 || { echo "[Error]: Installing final-gcc failed"; exit 1; }
echo "Installing final-gcc done">>${LOGFILE}


