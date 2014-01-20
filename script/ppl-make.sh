#!/bin/bash
LOGFILE="ppl_make.log"
echo "Compiling PPL starts" >${LOGFILE}
#make -j${CPU_NUM} -l >>${LOGFILE}  
make -j${CPU_NUM} -l >>${LOGFILE} 2>&1 || { echo "Compiling PPL failed"; exit 1; }
echo "Compiling PPL done">>${LOGFILE}

echo "Installing PPL starts" >>${LOGFILE}
make -j${CPU_NUM} -l install >>${LOGFILE} 2>&1 || { echo "Installing PPL failed"; exit 1;}
#make install >>${LOGFILE}
echo "Installing PPL done">>${LOGFILE}

