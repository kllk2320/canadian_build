#!/bin/bash
LOGFILE="mpc_make.log"

echo "Compiling MPC starts" >${LOGFILE}
#make -j${CPU_NUM} install >>${LOGFILE} 2>&1
make -j${CPU_NUM} -l >>${LOGFILE} 2>&1 || { echo "compiling mpc failed"; exit 1; }
echo "Compiling MPC done">>${LOGFILE}
echo "Installing MPC starts" >>${LOGFILE}
make install >>${LOGFILE} 2>&1 || { echo "Installing mpc failed"; exit 1; }
echo "Installing MPC done">>${LOGFILE}

