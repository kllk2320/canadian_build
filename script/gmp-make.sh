#!/bin/bash
LOGFILE="gmp_make.log"
echo "Compiling GMP starting" >${LOGFILE}
make -j4 -l >>${LOGFILE} 2>&1 || { echo "Compiling GMP failed"; exit 1; }
#make -j4 -l >>${LOGFILE} 
#ret=$?
#if [ $ret -ne 0 ];
#then
#    echo "Making all failed"
#    exit $ret
#fi
echo "Compiling GMP done">>${LOGFILE}
echo "Installing GMP starting" >> ${LOGFILE}
make install >>${LOGFILE} 2>&1 || { echo "Installing GMP failed"; exit 1; }

#make install >>${LOGFILE}
#ret=$?
#if [ $ret -ne 0 ];
#then
#    echo "Making all failed"
#    exit $ret
#fi
echo "Installing GMP done" >> ${LOGFILE}

