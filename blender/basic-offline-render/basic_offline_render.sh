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

# ensure packages are installed
apt-get install -y blender wget unzip hipcc

if [ ! -e classroom.zip ]; then
    echo "Downloading classroom.zip to $(pwd)"
    wget --continue https://download.blender.org/demo/test/classroom.zip
    unzip classroom.zip
else
    echo "classroom.zip already exists"
fi

blender -b classroom/classroom.blend -o $PWD/class_render_ -f 0 -F PNG -x 1 -- --cycles-device HIP --cycles-print-stats --offline-mode

exit
