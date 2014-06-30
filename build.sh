#!/bin/bash


#First specify the triplet
BUILD=x86_64-build-linux
HOST=i686-w64-mingw32
#HOST=i586-mingw32msvc
TARGET=arm-pi-linux-gnueabi



BUILD_DIR="${PWD}/build"
XTOOLS_DIR="${PWD}/x-tools"
SRC_DIR="${PWD}/src"
PKGVERSION="lk_dissertaion-1.0.1"

##0 Setup the build environment
#rm -rf ${BUILD_DIR}
#rm -rf ${XTOOLS_DIR}
#
#mkdir -p ${BUILD_DIR}
#mkdir -p ${BUILD_DIR}/libs-build
#mkdir -p ${BUILD_DIR}/libs-host
#
#mkdir -p ${XTOOLS_DIR}
#mkdir -p ${XTOOLS_DIR}/cct-bt
#mkdir -p ${XTOOLS_DIR}/cct-bt/sysroot
#mkdir -p ${XTOOLS_DIR}/cct-bh
#mkdir -p ${XTOOLS_DIR}/cct-bh/sysroot
#mkdir -p ${XTOOLS_DIR}/cct-ht
#mkdir -p ${XTOOLS_DIR}/cct-ht/sysroot

LIBS_BUILD=${BUILD_DIR}/libs-build
LIBS_HOST=${BUILD_DIR}/libs-host

CCT_BT_PREFIX=${XTOOLS_DIR}/cct-bt
CCT_BT_SYSROOT=${CCT_BT_PREFIX}/sysroot

CCT_BH_PREFIX=${XTOOLS_DIR}/cct-bh
CCT_BH_SYSROOT=${CCT_BH_PREFIX}/sysroot

CCT_HT_PREFIX=${XTOOLS_DIR}/cct-ht
CCT_HT_SYSROOT=${CCT_HT_PREFIX}/sysroot

CPU_NUM=8

GMP_SRC_DIR=${SRC_DIR}/gmp
MPFR_SRC_DIR=${SRC_DIR}/mpfr
MPC_SRC_DIR=${SRC_DIR}/mpc
PPL_SRC_DIR=${SRC_DIR}/ppl
CLOOG_PPL_SRC_DIR=${SRC_DIR}/cloog-ppl
BINUTILS_SRC_DIR=${SRC_DIR}/binutils
GLIBC_SRC_DIR=${SRC_DIR}/glibc
GCC_SRC_DIR=${SRC_DIR}/gcc
MINGW_SRC_DIR=${SRC_DIR}/mingw-w64
GDB_SRC_DIR=${SRC_DIR}/gdb
LINUX_SRC_DIR=${SRC_DIR}/linux
EXPAT_SRC_DIR=${SRC_DIR}/expat

#Add the bin directory to the 'PATH' variable
export PATH=${PATH}:${CCT_BT_PREFIX}/bin:${CCT_BH_PREFIX}/bin

#1.build the compiler cct-bt (x86-linux-hosted/arm-linux-targeted)
echo "==========================================================>>"
echo "        Start Building cct-build-target                     "
echo "============================================================"




#1.1 Build The GMP library for build
echo "==========================================================>>"
echo "        Building GMP library for build machine              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-gmp-build
cd ${BUILD_DIR}/build-gmp-build
export CFLAGS="-O2 -pipe" 
${GMP_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --prefix=${LIBS_BUILD} --enable-cxx --disable-shared --enable-mpbsd 1>log.txt 2>&1 || { echo "Configuring GMP failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling GMP failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling GMP failed"; exit 1; }

#1.2 Build The MPFR library for build
echo "==========================================================>>"
echo "        Building MPFR library for build machine             "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mpfr-build
cd ${BUILD_DIR}/build-mpfr-build
export CFLAGS="-O2 -pipe" 
${MPFR_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --prefix=${LIBS_BUILD} --with-gmp=${LIBS_BUILD} --disable-shared 1>log.txt 2>&1 || { echo "Configuring MPFR failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }

#1.3 Build The MPC library for build
echo "==========================================================>>"
echo "        Building MPC library for build machine              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mpc-build
cd ${BUILD_DIR}/build-mpc-build
export CFLAGS="-O2 -pipe" 
${MPC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --prefix=${LIBS_BUILD} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --disable-shared 1>log.txt 2>&1 || { echo "Configuring MPFR failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }

#1.4 Build The PPL library for build
echo "==========================================================>>"
echo "        Building PPL library for build machine              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-ppl-build
cd ${BUILD_DIR}/build-ppl-build
export CFLAGS="-O2 -pipe" 
${PPL_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --prefix=${LIBS_BUILD} --with-gmp=${LIBS_BUILD} --disable-shared --enable-watchdog --enable-interfaces="c c++" 1>log.txt 2>&1 || { echo "Configuring PPL failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling PPL failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling PPL failed"; exit 1; }


#1.5 Build The Cloog/PPL library for build
echo "==========================================================>>"
echo "        Building Cloog library for build machine            "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-cloog-ppl-build
cd ${BUILD_DIR}/build-cloog-ppl-build 
export CFLAGS="-O2 -pipe" 
${CLOOG_PPL_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --prefix=${LIBS_BUILD} --with-gmp=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --disable-shared --with-bits=gmp --with-host-libstdcxx=-lstdc++  1>log.txt 2>&1 || { echo "Configuring CLOOG/PPL failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling CLOOG/PPL failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling CLOOG/PPL failed"; exit 1; }

#1.6 Build the Binutils library for cct-bt
echo "==========================================================>>"
echo "        Building Binutls for cct-build-target               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-binutils-cct-bt
cd ${BUILD_DIR}/build-binutils-cct-bt 
export CFLAGS="-O2 -pipe" 
${BINUTILS_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${TARGET} --prefix=${CCT_BT_PREFIX} --with-sysroot=${CCT_BT_SYSROOT} --with-pkgversion=${PKGVERSION} --disable-werror --disable-multilib --disable-nls --disable-shared --enable-ld=yes --enable-gold=no  1>log.txt 2>&1 || { echo "Configuring Binutils failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }

#1.7 Build the core-pass-1 for cct-bt
echo "==========================================================>>"
echo "        Building core-pass-1 for cct-build-target           "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-core-pass-1-cct-bt
cd ${BUILD_DIR}/build-core-pass-1-cct-bt 
export CFLAGS="-O2 -pipe" 
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${TARGET} --prefix=${CCT_BT_PREFIX} --without-headers --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --with-mpc=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --with--cloog=${LIBS_BUILD} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_BUILD}/lib -lpwl" 1>log.txt 2>&1 || { echo "Configuring core-pass-1 failed"; exit 1; }
make -j${CPU_NUM} all-gcc 1>>log.txt 2>&1 || { echo "Compiling core-pass-1 failed"; exit 1; }
make -j${CPU_NUM} install-gcc 1>>log.txt 2>&1 || { echo "Installing core-pass-1 failed"; exit 1; }

#1.8 Build the linux kernel headers for cct-bt
echo "==========================================================>>"
echo "        Installing kerel headers for cct-build-target       "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-kernel-headers-cct-bt
cd ${BUILD_DIR}/build-kernel-headers-cct-bt
export CFLAGS="-O2 -pipe" 
make -C ${LINUX_SRC_DIR} O=${PWD} ARCH=arm INSTALL_HDR_PATH=${CCT_BT_SYSROOT}/usr V=0 headers_install 1>log.txt 2>&1 || { echo "Installing kernel headers failed"; exit 1; }

#1.9 Build the libc-startfiles for cct-bt
echo "==========================================================>>"
echo "        Building Glibc startfiles for cct-build-target      "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-glibc-startfiles-cct-bt
cd ${BUILD_DIR}/build-glibc-startfiles-cct-bt
export CFLAGS="-O2 -pipe" 
${GLIBC_SRC_DIR}/configure --build=${BUILD} --host=${TARGET} --prefix=/usr --with-headers=${CCT_BT_SYSROOT}/usr/include --with-pkgversion=${PKGVERSION} libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes 1>log.txt 2>&1 || { echo "Configuring libc-startfiles failed"; exit 1; }

make -j${CPU_NUM} install_root=${CCT_BT_SYSROOT} install-bootstrap-headers=yes install-headers 1>>log.txt 2>&1 || { echo "Installing libc headers failed"; exit 1;}
touch  ${CCT_BT_SYSROOT}/usr/include/gnu/stubs.h
cp bits/stdio_lim.h ${CCT_BT_SYSROOT}/usr/include/bits
mkdir -p ${CCT_BT_SYSROOT}/usr/lib
make -j${CPU_NUM} csu/subdir_lib 1>>log.txt 2>&1 || { echo "Compiling libc-startfiles failed"; exit 1; }
cp csu/crti.o csu/crtn.o ${CCT_BT_SYSROOT}/usr/lib
${TARGET}-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o ${CCT_BT_SYSROOT}/usr/lib/libc.so


#1.10 Build the core-pass-2 for cct-bt
echo "==========================================================>>"
echo "        Building core-pass-2 for cct-build-target           "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-core-pass-2-cct-bt
cd ${BUILD_DIR}/build-core-pass-2-cct-bt 
export CFLAGS="-O2 -pipe" 
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${TARGET} --prefix=${CCT_BT_PREFIX} --with-local-prefix=${CCT_BT_SYSROOT} --with-sysroot=${CCT_BT_SYSROOT} --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --with-mpc=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --with--cloog=${LIBS_BUILD} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_BUILD}/lib -lpwl" --enable-languages=c --disable-multilib --disable-nls  1>log.txt 2>&1 || { echo "Configuring core-pass-2 failed"; exit 1; }
make -j${CPU_NUM} all-gcc all-target-libgcc 1>>log.txt 2>&1 || { echo "Compiling core-pass-2 failed"; exit 1; }
make -j${CPU_NUM} install-gcc install-target-libgcc 1>>log.txt 2>&1 || { echo "Installing core-pass-2 failed"; exit 1; }

#1.11 Build the glibc for cct-bt
echo "==========================================================>>"
echo "        Building Glibc for cct-build-target                 "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-glibc-cct-bt
cd ${BUILD_DIR}/build-glibc-cct-bt
export CFLAGS="-O2" 
${GLIBC_SRC_DIR}/configure --build=${BUILD} --host=${TARGET} --prefix=/usr --with-headers=${CCT_BT_SYSROOT}/usr/include --with-pkgversion=${PKGVERSION} --enable-add-on=nptl,ports libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes 1>log.txt 2>&1 || { echo "Configuring libc failed"; exit 1; }
make -j${CPU_NUM} all 1>>log.txt 2>&1 || { echo "Compiling libc failed "; exit 1; }
make -j${CPU_NUM} install_root=${CCT_BT_SYSROOT} install 1>>log.txt 2>&1 || { echo "Installing libc failed "; exit 1; }

#1.12 Build the final gcc for cct-bt
echo "==========================================================>>"
echo "        Building final gcc for cct-build-target             "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-final-gcc-cct-bt
cd ${BUILD_DIR}/build-final-gcc-cct-bt 
export CFLAGS="-O2 -pipe" 
#export CFLAGS_FOR_TARGET="-mlittle-endian -mhard-float -march=armv6 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp"
#export CXXFLAGS_FOR_TARGET="-mlittle-endian -mhard-float -march=armv6 -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp"
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${TARGET} --prefix=${CCT_BT_PREFIX} --with-local-prefix=${CCT_BT_SYSROOT} --with-sysroot=${CCT_BT_SYSROOT} --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --with-mpc=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --with--cloog=${LIBS_BUILD} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_BUILD}/lib -lpwl" --enable-threads=posix --enable-languages=c,c++ --disable-multilib --disable-nls  1>log.txt 2>&1 || { echo "Configuring core-pass-2 failed"; exit 1; }
make -j${CPU_NUM} all 1>>log.txt 2>&1 || { echo "Compiling core-pass-2 failed"; exit 1; }
make -j${CPU_NUM} install 1>>log.txt 2>&1 || { echo "Installing core-pass-2 failed"; exit 1; }


#2 build the compiler cct-bh (x86-linux-hosted/Windows-targeted)
echo "==========================================================>>"
echo "        Start building cct-build-host                       "
echo "==========================================================<<"

#2.1 build the binutils for cct-bh
echo "==========================================================>>"
echo "        Building Binutls for cct-build-host                 "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-binutils-cct-bh
cd ${BUILD_DIR}/build-binutils-cct-bh 
export CFLAGS="-O2 -pipe" 
${BINUTILS_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${HOST} --prefix=${CCT_BH_PREFIX} --with-sysroot=${CCT_BH_SYSROOT} --with-pkgversion=${PKGVERSION} --disable-werror --disable-multilib --disable-nls --enable-ld=yes --enable-gold=no  1>log.txt 2>&1 || { echo "Configuring Binutils failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }


#2.2 install MinGW-w64 headers for cct-bh
echo "==========================================================>>"
echo "        Installing MinGW-w64 headers for cct-build-host     "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mingw-headers-cct-bh
cd ${BUILD_DIR}/build-mingw-headers-cct-bh 
${MINGW_SRC_DIR}/mingw-w64-headers/configure --build=${BUILD} --host=${HOST} --prefix=${CCT_BH_SYSROOT} 1>log.txt 2>&1 ||{ echo "Configuring MinGW Headers failed"; exit 1;} 
make install 1>>log.txt 2>&1 || { echo "Compiling MinGW Headers failed"; exit 1; }
ln -s ${CCT_BH_SYSROOT}/${HOST} ${CCT_BH_SYSROOT}/mingw

#2.3 build the core-pass for cct-bh
echo "==========================================================>>"
echo "        Building core-pass for cct-build-host               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-core-pass-cct-bh
cd ${BUILD_DIR}/build-core-pass-cct-bh
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${HOST} --prefix=${CCT_BH_PREFIX} --with-sysroot=${CCT_BH_SYSROOT} --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --with-mpc=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --with--cloog=${LIBS_BUILD} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_BUILD}/lib -lpwl" 1>log.txt 2>&1 || { echo "Configuring the core pass failed"; exit 1; }
make -j${CPU_NUM} all-gcc 1>>log.txt 2>&1 || { echo "Compiling the core pass failed"; exit 1; }
make install-gcc 1>>log.txt 2>&1 || { echo "Installing the core pass failed"; exit 1; }

#2.4 build the MinGW-w64 for cct-bh
echo "==========================================================>>"
echo "        Building MinGW-w64 for cct-build-host               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mingw-cct-bh
cd ${BUILD_DIR}/build-mingw-cct-bh 
${MINGW_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${CCT_BH_SYSROOT} 1>log.txt 2>&1 ||{ echo "Configuring MinGW Headers failed"; exit 1;} 
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling the MinGW failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Installing the MinGW failed"; exit 1; }

sed -i '
/<crtdefs.h>/ a\
typedef int daddr_t;\
typedef char *  caddr_t;
' ${CCT_BH_SYSROOT}/mingw/include/sys/types.h 

#2.5 build the final compiler
echo "==========================================================>>"
echo "        Building final gcc for cct-build-host               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-final-gcc-cct-bh
cd ${BUILD_DIR}/build-final-gcc-cct-bh
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${BUILD} --target=${HOST} --prefix=${CCT_BH_PREFIX} --with-sysroot=${CCT_BH_SYSROOT} --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_BUILD} --with-mpfr=${LIBS_BUILD} --with-mpc=${LIBS_BUILD} --with-ppl=${LIBS_BUILD} --with--cloog=${LIBS_BUILD} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_BUILD}/lib -lpwl"  --enable-languages=c,c++  --enable-__cxa_atexit --disable-multilib 1>log.txt 2>&1 || { echo "Configuring the final gcc failed"; exit 1; }
make -j${CPU_NUM} all 1>>log.txt 2>&1 || { echo "Compiling the final gcc failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Installing the final gcc failed"; exit 1; }


#3.build the compilers cct-ht (Windows-hosted/arm-linux-targeted) 
echo "==========================================================>>"
echo "        Start building cct-host-target                      "
echo "==========================================================<<"


#3.1 Build The GMP library for host
echo "==========================================================>>"
echo "        Building GMP library for host machine              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-gmp-host
cd ${BUILD_DIR}/build-gmp-host
export CFLAGS="-O2 -pipe" 
${GMP_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --enable-cxx --disable-shared --enable-mpbsd 1>log.txt 2>&1 || { echo "Configuring GMP failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling GMP failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling GMP failed"; exit 1; }

#3.2 Build The MPFR library for host
echo "==========================================================>>"
echo "        Building MPFR library for host machine              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mpfr-host
cd ${BUILD_DIR}/build-mpfr-host
export CFLAGS="-O2 -pipe" 
${MPFR_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --with-gmp=${LIBS_HOST} --disable-shared 1>log.txt 2>&1 || { echo "Configuring MPFR failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }

#3.3 Build The MPC library for host
echo "==========================================================>>"
echo "        Building MPC library for host machine               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-mpc-host
cd ${BUILD_DIR}/build-mpc-host
export CFLAGS="-O2 -pipe" 
${MPC_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --with-gmp=${LIBS_HOST} --with-mpfr=${LIBS_HOST} --disable-shared 1>log.txt 2>&1 || { echo "Configuring MPFR failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling MPFR failed"; exit 1; }

#3.4 Build The PPL library for host
echo "==========================================================>>"
echo "        Building PPL library for host machine               "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-ppl-host
cd ${BUILD_DIR}/build-ppl-host
export CFLAGS="-O2 -pipe" 
${PPL_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --with-gmp=${LIBS_HOST} --disable-shared --enable-watchdog --enable-interfaces="c c++" 1>log.txt 2>&1 || { echo "Configuring PPL failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling PPL failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling PPL failed"; exit 1; }

#3.5 Build The Cloog/PPL library for host
echo "==========================================================>>"
echo "        Building CLOOG library for host machine             "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-cloog-ppl-host
cd ${BUILD_DIR}/build-cloog-ppl-host 
export CFLAGS="-O2 -pipe" 
${CLOOG_PPL_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --with-gmp=${LIBS_HOST} --with-ppl=${LIBS_HOST} --disable-shared --with-bits=gmp --with-host-libstdcxx=-lstdc++  1>log.txt 2>&1 || { echo "Configuring CLOOG/PPL failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling CLOOG/PPL failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling CLOOG/PPL failed"; exit 1; }

#3.6 Build the binutils for cct-ht
echo "==========================================================>>"
echo "        Building Binutls for cct-host-target                "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-binutils-cct-ht
cd ${BUILD_DIR}/build-binutils-cct-ht 
export CFLAGS="-O2 -pipe" 
${BINUTILS_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --target=${TARGET} --prefix=${CCT_HT_PREFIX} --with-sysroot=${CCT_HT_SYSROOT} --with-pkgversion=${PKGVERSION} --disable-werror --disable-multilib --disable-nls --enable-ld=yes --enable-gold=no  1>log.txt 2>&1 || { echo "Configuring Binutils failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Compiling Binutils failed"; exit 1; }

#3.7 Build the linux kernel headers for cct-ht
echo "==========================================================>>"
echo "        Installing kerel headers for cct-host-target        "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-kernel-headers-cct-ht
cd ${BUILD_DIR}/build-kernel-headers-cct-ht
export CFLAGS="-O2 -pipe" 
make -C ${LINUX_SRC_DIR} O=${PWD} ARCH=arm INSTALL_HDR_PATH=${CCT_HT_SYSROOT}/usr V=0 headers_install 1>log.txt 2>&1 || { echo "Installing kernel headers failed"; exit 1; }

#3.8 Build the glibc for cct-ht
echo "==========================================================>>"
echo "        Building Glibc for cct-host-target                  "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-glibc-cct-ht
cd ${BUILD_DIR}/build-glibc-cct-ht
export CFLAGS="-O2" 
${GLIBC_SRC_DIR}/configure --build=${BUILD} --host=${TARGET} --prefix=/usr --with-pkgversion=${PKGVERSION} --enable-add-on=nptl,ports  1>log.txt 2>&1 || { echo "Configuring libc failed"; exit 1; }
make -j${CPU_NUM} all 1>>log.txt 2>&1 || { echo "Compiling libc failed "; exit 1; }
make -j${CPU_NUM} install_root=${CCT_HT_SYSROOT} install 1>>log.txt 2>&1 || { echo "Installing libc failed "; exit 1; }

#3.9 Build the final compiler for cct-ht
echo "==========================================================>>"
echo "        Building final gcc for cct-host-target              "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-final-gcc-cct-ht
cd ${BUILD_DIR}/build-final-gcc-cct-ht
${GCC_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --target=${TARGET} --prefix=${CCT_HT_PREFIX} --with-sysroot=${CCT_HT_SYSROOT} --with-pkgversion=${PKGVERSION} --with-gmp=${LIBS_HOST} --with-mpfr=${LIBS_HOST} --with-mpc=${LIBS_HOST} --with-ppl=${LIBS_HOST} --with--cloog=${LIBS_HOST} --with-host-libstdcxx="-Wl,-Bstatic,-lstdc++,-Bdynamic -lm -L${LIBS_HOST}/lib -lpwl"  --enable-languages=c,c++  --enable-__cxa_atexit --disable-multilib 1>log.txt 2>&1 || { echo "Configuring the final gcc failed"; exit 1; }
make -j${CPU_NUM} all 1>>log.txt 2>&1 || { echo "Compiling the final gcc failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Installing the final gcc failed"; exit 1; }


#4 Build GNU debuger- gdb
echo "==========================================================>>"
echo "        Start building gdb for cct-host-target              "
echo "==========================================================<<"

#4.1 Build libexpat
echo "==========================================================>>"
echo "        Building libexpat for gdb                           "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-expat-host
cd ${BUILD_DIR}/build-expat-host
${EXPAT_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --prefix=${LIBS_HOST} --disable-shared 1>>log.txt 2>&1 || { echo "Configuring the expat failed"; exit 1; }

make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling the expat failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Installing the expat failed"; exit 1; }

#4.2 Build gdb client
echo "==========================================================>>"
echo "        Building gdb for gdb                                "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-gdb-cct-ht
cd ${BUILD_DIR}/build-gdb-cct-ht
${GDB_SRC_DIR}/configure --build=${BUILD} --host=${HOST} --target=${TARGET} --prefix=${CCT_HT_PREFIX} --with-sysroot=${CCT_HT_SYSROOT} --with-pkgversion=${PKGVERSION} --disable-werror --with-expat=yes --with-libexpat-prefix=${LIBS_HOST} 1>>log.txt 2>&1 || { echo "Configuring gdb client failed"; exit 1; }

make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling gdb client failed"; exit 1; }
make install 1>>log.txt 2>&1 || { echo "Installing gdb client failed"; exit 1; }

#4.3 Build gdb server
echo "==========================================================>>"
echo "        Building gdbserver for gdb                           "
echo "==========================================================<<"
mkdir -p ${BUILD_DIR}/build-gdbserver-cct-ht
cd ${BUILD_DIR}/build-gdbserver-cct-ht
${GDB_SRC_DIR}/gdb/gdbserver/configure --build=${BUILD} --host=${TARGET} --target=${TARGET} --with-pkgversion=${PKGVERSION} --prefix=/usr --program-prefix='' 1>log.txt 2>&1 || { echo "Configuring gdbserver failed"; exit 1; }
make -j${CPU_NUM} 1>>log.txt 2>&1 || { echo "Compiling gdbserver failed"; exit 1; }
make DESTDIR=${CCT_HT_PREFIX}/debug-root install 1>>log.txt 2>&1 || { echo "Installing gdbserver failed"; exit 1; }


#5 Strip the executable binaries to reduce package size
STRIP=${HOST}-strip
file=`find ${CCT_HT_PREFIX} -name \*.exe`
for f in ${file};
do
#    echo "$f"
    ${STRIP} $f
done

#6 Replace the soft link file, which Windows does not support, with the actual file it points to.
link_files=`find ${CCT_HT_PREFIX} -type l`
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


