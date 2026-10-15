#! /usr/bin/bash

################################################################################
# run_naive_kfdtst
#
# This is a _very_ simple script to build and run kfdtest.
#
# The method for building kfdtest depends on the ROCm version, so this script
# handles that automatically based on the detected linux distribution.
################################################################################

test_deb_rocm7 () {

    # install the prerequisites
    apt-get install -y libhsa-runtime-dev libhsakmt-dev libdrm-dev libnuma-dev cmake build-essential hipcc gdb pkg-config

    # get the runtime source
    git clone https://github.com/ROCm/ROCR-Runtime.git
    cd ROCR-Runtime
    git checkout $ROCR_RUNTIME_BRANCH

    ################################################################################
    # build kfdtest
    ################################################################################

    pushd libhsakmt/tests/kfdtest
    mkdir build
    pushd build

    export LIBHSAKMT_PATH=/usr/lib/x86_64-linux-gnu
    cmake ..

    cmake --build .


    ################################################################################
    # run kfdtest
    ################################################################################

    echo "debug information:"
    echo " current dir: $(pwd)"

    ls -l

    echo ""
    echo "running kfdtest"
    echo ""

    export KFDTEST_SHARE_DIR=$(pwd)
    export BIN_DIR=$(pwd)
    /usr/bin/bash run_kfdtest.sh

    #./kfdtest

    exit $?
}

test_deb_rocm10 () {

    ROCR_RUNTIME_BRANCH="release/therock-10.0"
    # install the prerequisites
    apt-get install -y libhsa-runtime-dev libhsakmt-dev libdrm-dev libnuma-dev cmake build-essential hipcc-rocm gdb pkg-config

    # get the runtime source
    git clone --depth 1 --single-branch --branch $ROCR_RUNTIME_BRANCH https://github.com/ROCm/rocm-systems.git
    cd rocm-systems
    #git checkout $ROCR_RUNTIME_BRANCH

    ################################################################################
    # build kfdtest
    ################################################################################

    pushd projects/rocr-runtime/libhsakmt/tests/kfdtest
    mkdir build
    pushd build

    export LIBHSAKMT_PATH=/usr/lib/x86_64-linux-gnu
    cmake -DCMAKE_PREFIX_PATH=/usr/lib/rocm ..

    cmake --build .


    ################################################################################
    # run kfdtest
    ################################################################################

    echo "debug information:"
    echo " current dir: $(pwd)"

    ls -l

    echo ""
    echo "running kfdtest"
    echo ""

    export KFDTEST_SHARE_DIR=$(pwd)
    export BIN_DIR=$(pwd)
    /usr/bin/bash run_kfdtest.sh

    #./kfdtest

    exit $?
}


DISTRO_ID=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2)

if [ $DISTRO_ID = "ubuntu" ]; then
    DISTRO_CODENAME=$(cat /etc/os-release | grep "^VERSION_CODENAME=" | cut -d'=' -f2)
    apt-get update

    if [ $DISTRO_CODENAME = "resolute" ]; then
        echo "Detected Ubuntu 26.04 (resolute), running kfdtest for ROCm 7\n"
        test_deb_rocm7
    fi
    if [ $DISTRO_CODENAME = "stonking" ]; then
        echo "Detected Ubuntu 24.10 (stonking), running kfdtest for ROCm 10\n"
        test_deb_rocm10
    fi  

fi

