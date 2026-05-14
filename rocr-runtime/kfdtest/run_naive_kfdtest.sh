#! /usr/bin/bash

################################################################################
# run_naive_kfdtst
#
# This is a _very_ simple script to build and run kfdtest.
#
# This assumes a version of rocr-runtime is being used, check before running it
# to make sure that your system has compatible versions
################################################################################

ROCR_RUNTIME_BRANCH="release/rocm-rel-7.1"

# install the prerequisites
apt-get install -y libhsa-runtime-dev libhsakmt-dev libdrm-dev libnuma-dev cmake build-essential hipcc pkg-config

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
