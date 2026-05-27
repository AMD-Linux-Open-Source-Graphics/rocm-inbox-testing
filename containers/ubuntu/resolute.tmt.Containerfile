# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM resolute-rocm-test-base
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"

############################################################
# enable the tflink/rocm-inbox-testing-tools PPA
############################################################

COPY tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources /etc/apt/sources.list.d/tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources

############################################################
# update apt metadata
############################################################

RUN echo "update apt metadata"; apt-get update

############################################################
# need cmake for some tests, rocminfo for system info,
# gdb for debugging
############################################################

RUN echo "Install test requirements"; apt-get install -y cmake rocminfo gdb tmt testrig

############################################################
# clean metadata to keep size down?
############################################################

RUN echo "cleaning apt metadata"; apt-get clean

CMD ["/usr/bin/bash"]

