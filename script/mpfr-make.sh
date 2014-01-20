#!/bin/bash
LOGFILE="mpfr_make.log"
echo "Compiling MPFR starting" >${LOGFILE}
#make -j4 -l >>${LOGFILE} 2>&1
make -j4 -l >>${LOGFILE} 2>&1 || { echo "compiling mpfr failed "; exit 1; }
echo "Compiling MPFR done">>${LOGFILE}
echo "Installing MPFR starting" >> ${LOGFILE}
#make install >>${LOGFILE} 2>&1
make install >>${LOGFILE} 2>&1 || { echo "Installing mpfr failed"; exit 1; }
echo "Installing MPFR done" >> ${LOGFILE}

