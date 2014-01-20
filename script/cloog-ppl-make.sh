#!/bin/bash
LOGFILE="cloog_make.log"

echo "Compiling CLOOG/PPL starts" >${LOGFILE}
#make -j4 install >>${LOGFILE} 2>&1
make -j4 -l libcloog.la >>${LOGFILE} 2>&1  || { echo "Compiling cloog/ppl failed"; exit 1; }
echo "Compiling CLOOG/PPL done">>${LOGFILE}

echo "Installing CLOOG/PPL starts" >>${LOGFILE}
make install-libLTLIBRARIES install-pkgincludeHEADERS >>${LOGFILE} 2>&1 || { echo "Compiling cloog/ppl failed"; exit 1; }
echo "Installing CLOOG/PPL done">>${LOGFILE}

