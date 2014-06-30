#!/bin/bash

#First specify the triplet
#BUILD=x86_64-build-linux
#HOST=x86_64-w64-mingw32
#HOST=i586-mingw32msvc
#TARGET=arm-unknown-linux-gnueabi
TOP=${PWD}
if [ -z "${ARG_BUILD}" ]; then
    BUILD=x86_64-build-linux
    export ARG_BUILD=${BUILD}
else
    BUILD=${ARG_BUILD}
fi

if [ -z "${ARG_HOST}" ]; then
    HOST=i586-mingw32msvc
    export ARG_HOST=${HOST}
else
    HOST=${ARG_HOST}
fi

if [ -z "${ARG_TARGET}" ]; then
    TARGET=arm-unknown-linux-gnueabi
    export ARG_TARGET=${TARGET}
else
    TARGET=${ARG_TARGET}
fi

build_target_toolchain=$1
build_host_toolchain=$2

if [[ $build_target_toolchain = "yes" || $build_host_toolchain = "yes" ]];
then
    #Step 1.1: build GMP for build
    GMP_FOR_BUILD_DIR=${TOP}/build-gmp-for-build
    echo "======================================>>"
    echo "Build GMP for build Start"
    cd ${GMP_FOR_BUILD_DIR}
    make distclean >/dev/null 2>&1
    echo "Building GMP"
    ./gmp-configure.sh build || { echo "configure gmp for build failed";exit 1; }
    ./gmp-make.sh || { echo "make gmp for build failed";exit 1; }
    echo "Build GMP for build Done"
    echo "======================================<<"
    
    #Step 1.2: build MPFR
    MPFR_FOR_BUILD_DIR=${TOP}/build-mpfr-for-build
    echo "======================================>>"
    echo "Build MPFR for build Start"
    cd ${MPFR_FOR_BUILD_DIR}
    make distclean >/dev/null 2>&1
    echo "Building MPFR"
    ./mpfr-configure.sh build || { echo "configure mpfr for build failed";exit 1; }
    ./mpfr-make.sh || { echo "make mpfr for build failed";exit 1; }
    echo "Build MPFR for build Done"
    echo "======================================<<"
    
    #Step 1.3: build MPC
    MPC_FOR_BUILD_DIR=${TOP}/build-mpc-for-build
    echo "======================================>>"
    echo "Build MPC for build Start"
    cd ${MPC_FOR_BUILD_DIR}
    make distclean >/dev/null 2>&1
    echo "Building MPC"
    ./mpc-configure.sh build || { echo "configure mpc for build failed";exit 1; }
    ./mpc-make.sh || { echo "make mpc for build failed";exit 1; }
    echo "Build MPC for build Done"
    echo "======================================<<"
    
    #Step 1.4: build PPL
    PPL_FOR_BUILD_DIR=${TOP}/build-ppl-for-build
    echo "======================================>>"
    echo "Build PPL for build Start"
    cd ${PPL_FOR_BUILD_DIR}
    make distclean >/dev/null 2>&1
    echo "Building PPL"
    cd ${PPL_FOR_BUILD_DIR}
    ./ppl-configure.sh build || { echo "configure ppl for build failed";exit 1; }
    ./ppl-make.sh || { echo "make ppl for build failed";exit 1; }
    echo "Build PPL for build Done"
    echo "======================================<<"
    
    #Step 1.5: build CLOOG/PPL
    CLOOG_FOR_BUILD_DIR=${TOP}/build-cloog-ppl-for-build
    echo "======================================>>"
    echo "Build CLOOG/PPL for build Start"
    cd ${CLOOG_FOR_BUILD_DIR}
    make distclean >/dev/null 2>&1
    echo "Building CLOOG/PPL"
    ./cloog-ppl-configure.sh build || { echo "configure cloog/ppl for build failed";exit 1; }
    ./cloog-ppl-make.sh || { echo "make cloog/ppl for build failed";exit 1; }
    echo "Build CLOOG/PPL for build Done"
    echo "======================================<<"
    
fi

# we need to build the cross-compilers for host and target respectively before building other components
# first, we build the cross-compiler for host
if [[ $build_host_toolchain = "yes" ]];
then

    #Step 2.1: build Binutils for host
    BINUTILS_FOR_HOST_DIR=${TOP}/build-binutils-for-host
    echo "======================================>>"
    echo "Build Binutils for host Start"
    cd ${BINUTILS_FOR_HOST_DIR}
    make distclean >/dev/null 2>&1
    echo "Building Binutils"
    ./binutils-configure.sh host || { echo "configure binutils for host failed";exit 1; }
    ./binutils-make.sh || { echo "make binutils for host failed";exit 1; }
    echo "Build Binutils for host Done"
    echo "======================================<<"
    
    #Step 2.2: build mingw headers for host
    MINGW_HEADER_DIR=${TOP}/build-mingw-header
    echo "======================================>>"
    echo "Build Mingw headers for host Start"
    cd ${MINGW_HEADER_DIR}
    make distclean >/dev/null 2>&1
    echo "Building Mingw headers"
    ./mingw-header-configure.sh host || { echo "configure mingw-header for host failed";exit 1; }
    ./mingw-header-make.sh || { echo "make mingw-header for host failed";exit 1; }
    echo "Build Mingw headers for host Done"
    echo "======================================<<"
    
    #Step 2.3: build core-pass 2 gcc for host
    CORE_PASS_2_FOR_HOST_DIR=${TOP}/build-core-pass-2-for-host
    echo "======================================>>"
    echo "Build core-pass-2 for host Start"
    cd ${CORE_PASS_2_FOR_HOST_DIR}
    make distclean >/dev/null 2>&1
    echo "Building core-pass-2 for host"
    ./core-pass-2-configure.sh host || { echo "configure core-pass-2 for host failed";exit 1; }
    ./core-pass-2-make.sh || { echo "make core-pass-2 for host failed";exit 1; }
    echo "Build core-pass-2 for host Done"
    echo "======================================<<"
    
    #Step 2.4: build mingw for host
    MINGW_DIR=${TOP}/build-mingw
    echo "======================================>>"
    echo "Build Mingw for host Start"
    cd ${MINGW_DIR}
    make distclean >/dev/null 2>&1
    echo "Building Mingw"
    ./mingw-configure.sh host || { echo "configure mingw for host failed";exit 1; }
    ./mingw-make.sh || { echo "make mingw for host failed";exit 1; }
    echo "Build Mingw for host Done"
    echo "======================================<<"
    
    
    #Step 2.5: build final for host
    FINAL_GCC_FOR_HOST_DIR=${TOP}/build-final-gcc-for-host
    echo "======================================>>"
    echo "Build final-gcc for host Start"
    cd ${FINAL_GCC_FOR_HOST_DIR}
    make distclean >/dev/null 2>&1
    echo "Building final-gcc for host"
    ./final-gcc-configure.sh host || { echo "configure final-gcc for host failed";exit 1; }
    ./final-gcc-make.sh || { echo "make final-gcc for host failed";exit 1; }
    echo "Build final-gcc for host Done"
    echo "======================================<<"

fi

if [ $build_target_toolchain = "yes" ];
then
    #Step 3.1: build Binutils for target
    BINUTILS_FOR_TARGET_DIR=${TOP}/build-binutils-for-target
    echo "======================================>>"
    echo "Build Binutils for target Start"
    cd ${BINUTILS_FOR_TARGET_DIR}
    make distclean >/dev/null 2>&1
    echo "Building Binutils"
    ./binutils-configure.sh target || { echo "configure binutils for target failed";exit 1; }
    ./binutils-make.sh || { echo "make binutils for target failed";exit 1; }
    echo "Build Binutils for target Done"
    echo "======================================<<"
    
    #Step 3.2: build core-pass-1 for target
    CORE_PASS_1_FOR_TARGET_DIR=${TOP}/build-core-pass-1-for-target
    echo "======================================>>"
    echo "Build core-pass-1 for target Start"
    cd ${CORE_PASS_1_FOR_TARGET_DIR}
    make distclean >/dev/null 2>&1
    echo "Building core-pass-1 for target"
    ./core-pass-1-configure.sh target || { echo "configure core-pass-1 for target failed";exit 1; }
    ./core-pass-1-make.sh || { echo "make core-pass-1 for target failed";exit 1; }
    echo "Build core-pass-1 for target Done"
    echo "======================================<<"

    #Step 3.3: build linux headers
    KERNEL_HEADER_DIR=${TOP}/build-kernel-header
    echo "======================================>>"
    echo "Build KERNEL_HEADER Start"
    cd ${KERNEL_HEADER_DIR}
    make distclean >/dev/null 2>&1
    echo "Building KERNEL_HEADER"
    ./kernel-header-make.sh || { echo "make kernel-header failed";exit 1; }
    echo "Build KERNEL_HEADER Done"
    echo "======================================<<"
    
    #Step 3.4: build libc startfiles for target
    LIBC_STARTFILES_FOR_TARGET_DIR=${TOP}/build-libc-startfiles-for-target
    echo "======================================>>"
    echo "Build libc startfiles Start"
    cd ${LIBC_STARTFILES_FOR_TARGET_DIR}
    make distclean >/dev/null 2>&1
    echo "Building libc startfiles"
    cd ${LIBC_STARTFILES_FOR_TARGET_DIR}
    ./libc-startfiles-configure.sh || { echo "configure libc startfiles failed";exit 1; }
    ./libc-startfiles-make.sh || { echo "make libc startfiles failed";exit 1; }
    echo "Build libc startfiles Done"
    echo "======================================<<"
    
    #Step 3.5: build core-pass-2 for target
    CORE_PASS_1_FOR_TARGET_DIR=${TOP}/build-core-pass-2-for-target
    echo "======================================>>"
    echo "Build core-pass-2 for target Start"
    cd ${CORE_PASS_1_FOR_TARGET_DIR}
    make distclean >/dev/null 2>&1
    echo "Building core-pass-2 for target"
    ./core-pass-2-configure.sh target || { echo "configure core-pass-2 for target failed";exit 1; }
    ./core-pass-2-make.sh || { echo "make core-pass-2 for target failed";exit 1; }
    echo "Build core-pass-2 for target Done"
    echo "======================================<<"
    
    #Step 3.6: build libc
    LIBC_DIR=${TOP}/build-libc-for-target
    echo "======================================>>"
    echo "Build libc Start"
    cd ${LIBC_DIR}
    make distclean >/dev/null 2>&1
    echo "Building libc"
    cd ${LIBC_DIR}
    ./libc-configure.sh || { echo "configure libc failed";exit 1; }
    ./libc-make.sh || { echo "make libc failed";exit 1; }
    echo "Build libc Done"
    echo "======================================<<"
    
    #Step 3.7: build final for target
    FINAL_GCC_FOR_TARGET_DIR=${TOP}/build-final-gcc-for-target
    echo "======================================>>"
    echo "Build final-gcc for target Start"
    cd ${FINAL_GCC_FOR_TARGET_DIR}
    make distclean >/dev/null 2>&1
    echo "Building final-gcc for target"
    ./final-gcc-configure.sh target || { echo "configure final-gcc for target failed";exit 1; }
    ./final-gcc-make.sh || { echo "make final-gcc for target failed";exit 1; }
    echo "Build final-gcc for target Done"
    echo "======================================<<"
fi

#Step 4.1: build GMP for host
GMP_FOR_HOST_DIR=${TOP}/build-gmp-for-host
echo "======================================>>"
echo "Build GMP for host Start"
cd ${GMP_FOR_HOST_DIR}
make distclean >/dev/null 2>&1
echo "Building GMP"
./gmp-configure.sh host || { echo "configure gmp for host failed";exit 1; }
./gmp-make.sh || { echo "make gmp for host failed";exit 1; }
echo "Build GMP for host Done"
echo "======================================<<"

#Step 4.2: build MPFR
MPFR_FOR_HOST_DIR=${TOP}/build-mpfr-for-host
echo "======================================>>"
echo "Build MPFR for host Start"
cd ${MPFR_FOR_HOST_DIR}
make distclean >/dev/null 2>&1
echo "Building MPFR"
./mpfr-configure.sh host || { echo "configure mpfr for host failed";exit 1; }
./mpfr-make.sh || { echo "make mpfr for host failed";exit 1; }
echo "Build MPFR for host Done"
echo "======================================<<"

#Step 4.3: build MPC
MPC_FOR_HOST_DIR=${TOP}/build-mpc-for-host
echo "======================================>>"
echo "Build MPC for host Start"
cd ${MPC_FOR_HOST_DIR}
make distclean >/dev/null 2>&1
echo "Building MPC"
./mpc-configure.sh host || { echo "configure mpc for host failed";exit 1; }
./mpc-make.sh || { echo "make mpc for host failed";exit 1; }
echo "Build MPC for host Done"
echo "======================================<<"

#Step 4.4: build PPL
PPL_FOR_HOST_DIR=${TOP}/build-ppl-for-host
echo "======================================>>"
echo "Build PPL for host Start"
cd ${PPL_FOR_HOST_DIR}
make distclean >/dev/null 2>&1
echo "Building PPL"
cd ${PPL_FOR_HOST_DIR}
./ppl-configure.sh host || { echo "configure ppl for host failed";exit 1; }
./ppl-make.sh || { echo "make ppl for host failed";exit 1; }
echo "Build PPL for host Done"
echo "======================================<<"

#Step 4.5: build CLOOG/PPL
CLOOG_FOR_HOST_DIR=${TOP}/build-cloog-ppl-for-host
echo "======================================>>"
echo "Build CLOOG/PPL for host Start"
cd ${CLOOG_FOR_HOST_DIR}
make distclean >/dev/null 2>&1
echo "Building CLOOG/PPL"
./cloog-ppl-configure.sh host || { echo "configure cloog/ppl for host failed";exit 1; }
./cloog-ppl-make.sh || { echo "make cloog/ppl for host failed";exit 1; }
echo "Build CLOOG/PPL for host Done"
echo "======================================<<"

#Step 4.6: build Binutils for final
BINUTILS_FOR_FINAL_DIR=${TOP}/build-binutils-for-final
echo "======================================>>"
echo "Build Binutils for final Start"
cd ${BINUTILS_FOR_FINAL_DIR}
make distclean >/dev/null 2>&1
echo "Building Binutils"
./binutils-configure.sh final || { echo "configure binutils for final failed";exit 1; }
./binutils-make.sh || { echo "make binutils for final failed";exit 1; }
echo "Build Binutils for final Done"
echo "======================================<<"

if [ $build_target_toolchain != "yes" ];
then

#Step 4.7: build linux headers
KERNEL_HEADER_DIR=${TOP}/build-kernel-header
echo "======================================>>"
echo "Build KERNEL_HEADER Start"
cd ${KERNEL_HEADER_DIR}
make distclean >/dev/null 2>&1
echo "Building KERNEL_HEADER"
./kernel-header-make.sh || { echo "make kernel-header failed";exit 1; }
echo "Build KERNEL_HEADER Done"
echo "======================================<<"

#Step 4.8: build libc
LIBC_DIR=${TOP}/build-libc-for-target
echo "======================================>>"
echo "Build libc Start"
cd ${LIBC_DIR}
make distclean >/dev/null 2>&1
echo "Building libc"
cd ${LIBC_DIR}
./libc-configure.sh || { echo "configure libc failed";exit 1; }
./libc-make.sh || { echo "make libc failed";exit 1; }
echo "Build libc Done"
echo "======================================<<"

fi

#Step 4.9: build final gcc 
FINAL_GCC_FOR_FINAL_DIR=${TOP}/build-final-gcc-for-final
echo "======================================>>"
echo "Build final-gcc for final Start"
cd ${FINAL_GCC_FOR_FINAL_DIR}
make distclean >/dev/null 2>&1
echo "Building final-gcc for final"
./final-gcc-configure.sh final || { echo "configure final-gcc for final failed";exit 1; }
./final-gcc-make.sh || { echo "make final-gcc for final failed";exit 1; }
echo "Build final-gcc for final Done"
echo "======================================<<"

#Step 4.10: build libexpat 
LIBEXPAT_FOR_FINAL_DIR=${TOP}/build-libexpat-for-final
echo "======================================>>"
echo "Build libexpat for final Start"
cd ${LIBEXPAT_FOR_FINAL_DIR}
make distclean >/dev/null 2>&1
echo "Building libexpat for final"
./libexpat-configure.sh || { echo "configure libexpat for final failed";exit 1; }
./libexpat-make.sh || { echo "make libexpat for final failed";exit 1; }
echo "Build libexpat for final Done"
echo "======================================<<"

#Step 4.10: build cross-gdb 
CROSS_GDB_FOR_FINAL_DIR=${TOP}/build-cross-gdb-for-final
echo "======================================>>"
echo "Build cross-gdb for final Start"
cd ${CROSS_GDB_FOR_FINAL_DIR}
make distclean >/dev/null 2>&1
echo "Building cross-gdb for final"
./cross-gdb-configure.sh || { echo "configure cross-gdb for final failed";exit 1; }
./cross-gdb-make.sh || { echo "make cross-gdb for final failed";exit 1; }
echo "Build cross-gdb for final Done"
echo "======================================<<"

#Step 4.11: build gdbserver 
GDBSERVER_FOR_TARGET_DIR=${TOP}/build-gdbserver-for-target
echo "======================================>>"
echo "Build gdbserver for final Start"
cd ${GDBSERVER_FOR_TARGET_DIR}
make distclean >/dev/null 2>&1
echo "Building gdbserver for final"
./gdbserver-configure.sh || { echo "configure gdbserver for final failed";exit 1; }
./gdbserver-make.sh || { echo "make gdbserver for final failed";exit 1; }
echo "Build gdbserver for final Done"



#Strip the executable binaries to reduce package size
XTOOLS_DIR=${TOP}/../x-tools
STRIP=${HOST}-strip

file=`find ${XTOOLS_DIR} -name \*.exe`

for f in ${file};
do
#    echo "$f"
    ${STRIP} $f
done

#replace each soft link file, which Windows doesn't support, with the actual file it points to.
link_files=`find ${XTOOLS_DIR} -type l`
ls_files=`ls -l $link_files | awk '{print $9, $11}' | sed -n 's/ /:/p'`

for f in $ls_files;
do
    link_f=${f%%:*}
    link_prefix=`dirname $link_f`
    origin_f_sufix=${f##*:}
    origin_f=$link_prefix/$origin_f_sufix
    if [ -f $origin_f ];
    then
        rm $link_f 
        cp $origin_f $link_f
    fi 
done








