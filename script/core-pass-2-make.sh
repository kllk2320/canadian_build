#!/bin/bash
LOGFILE="core-pass-2_make.log"

echo "Compiling core-pass-2 starts" >${LOGFILE}
#make -j4 install >>${LOGFILE} 2>&1
#make  -j4 -l configure-gcc configure-libcpp configure-build-libiberty >>${LOGFILE}
#make  -j4 -l all-libcpp all-build-libiberty >>${LOGFILE} 
#make  -j4 -l configure-libdecnumber >>${LOGFILE} 
#make  -j4 -l -C libdecnumber libdecnumber.a >>${LOGFILE} 
#make  -j4 -l -C gcc libgcc.mvars >>${LOGFILE} 
#make  -j4 -l all-gcc all-target-libgcc >>${LOGFILE} 
make  -j4 -l configure-gcc configure-libcpp configure-build-libiberty >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling congiugure-gcc .. failed"; exit 1; }
make  -j4 -l all-libcpp all-build-libiberty >>${LOGFILE}  2>&1 || { echo "[Error]: Compiling all-libcpp ... failed"; exit 1; }
make  -j4 -l configure-libdecnumber >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling configure-libdecnumber failed"; exit 1; }
make  -j4 -l -C libdecnumber libdecnumber.a >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling libdecnumber ... failed"; exit 1; }
make  -j4 -l -C gcc libgcc.mvars >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling gcc ... failed"; exit 1; }
make  -j4 -l all-gcc all-target-libgcc >>${LOGFILE} 2>&1 || { echo "[Error]: Compiling all-gcc ... failed"; exit 1; }
echo "Compiling core-pass-2 done">>${LOGFILE}

echo "Installing core-pass-2 starts" >>${LOGFILE}
make  -j4 -l install-gcc install-target-libgcc >>${LOGFILE} 2>&1 || { echo "[Error]: Installing core-pass-2 failed"; exit 1; }
echo "Installing core-pass-2 done">>${LOGFILE}

