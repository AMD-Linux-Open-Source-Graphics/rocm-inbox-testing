# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM ubuntu:resolute
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"

ENV DEBIAN_FRONTEND=noninteractive

############################################################
# add proposed to the repo config
############################################################

RUN sed -i 's/resolute-backports/resolute-backports resolute-proposed/' /etc/apt/sources.list.d/ubuntu.sources

############################################################
# enable the tflink/rocm-inbox-testing-tools PPA
############################################################

COPY tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources /etc/apt/sources.list.d/tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources

############################################################
# update and install base system
############################################################
RUN echo "upgrading base image and installing dbgsym-keyring"; apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y ubuntu-dbgsym-keyring

############################################################
# enable ubuntu archive debug repos
############################################################

COPY resolute-ddebs.list /etc/apt/sources.list.d/ddebs.sources
RUN echo "updating apt metadata with debug"; apt-get update

############################################################
# install base tools
# need cmake for some tests, rocminfo for system info,
# gdb for debugging
############################################################

RUN echo "Install test requirements"; apt-get install --no-install-recommends -y vim bash git cmake rocminfo gdb tmt testrig

############################################################
# install all rocm test packages
############################################################

RUN echo "Install all ROCm test packages"; apt-get install --no-install-recommends -y rocm-tests

############################################################
# clone rocm-inbox-testing
############################################################

RUN git clone --depth=1 --branch main https://github.com/AMD-Linux-Open-Source-Graphics/rocm-inbox-testing.git /opt/rocm-inbox-testing

############################################################
# clean metadata to keep size down?
############################################################

RUN echo "cleaning apt metadata"; apt-get clean && rm -rf /var/lib/apt/lists/*

############################################################
# run the run_tests script in the checkout dir by default
############################################################

WORKDIR /opt/rocm-inbox-testing
CMD ["/usr/bin/bash","/opt/rocm-inbox-testing/run_tests.sh"]
