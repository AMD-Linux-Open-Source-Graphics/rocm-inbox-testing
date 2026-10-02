#! /usr/bin/bash

set -e

################################################################################
# This is a trivial test case to exercise blender to render a preset scene and
# offload some rendering to the GPU
#
# This test case should be replaced with something that is smarter and checks
# the output for some form of correctness instead of just assuming that a 0 exit
# code from blender means PASSED
################################################################################

# the hipcc-rocm package (using the amd fork of clang) is required for recent ROCm builds on Ubuntu
# right now, that is 26.10 and later (ROCm 7.14+)
install_apt_amdclang ()
{
    echo "Installing dependencies for ROCm built with amdclang"
    apt-get install -y blender wget unzip build-essential hipcc-rocm
}

# hipcc uses system clang and is appropriate for older Ubuntu versions (26.04 and earlier) and Debian
install_apt_systemclang ()
{
    echo "Installing dependencies for ROCm built with systemclang"
    apt-get install -y blender wget unzip hipcc
}

# detect OS
. /etc/os-release


case "$ID" in
    ubuntu)
        # ensure that metadata is up to date
        apt-get update

        # handle dependencies per release
        if [ "$VERSION_ID" = "26.04" ]; then
            install_apt_systemclang
        else
            install_apt_amdclang
        fi
        ;;
    *)
        echo "Unsupported OS: $ID"
        exit 1
        ;;
esac


if [ ! -e classroom.zip ]; then
    echo "Downloading classroom.zip to $(pwd)"
    wget --continue https://download.blender.org/demo/test/classroom.zip
    unzip classroom.zip
else
    echo "classroom.zip already exists"
fi

blender -b classroom/classroom.blend -o $PWD/class_render_ -f 0 -F PNG -x 1 -- --cycles-device HIP --cycles-print-stats --offline-mode

exit
