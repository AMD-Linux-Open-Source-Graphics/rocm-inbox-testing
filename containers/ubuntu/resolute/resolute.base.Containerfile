# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM ubuntu:resolute
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"


############################################################
# enable any extra repos
############################################################

# this PPA has tools like fmf, tmt and testrig
COPY tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources /etc/apt/sources.list.d/tflink-ubuntu-rocm-inbox-testing-tools-resolute.sources

############################################################
# add proposed to the repo config
############################################################

RUN sed -i 's/resolute-backports/resolute-backports resolute-proposed/' /etc/apt/sources.list.d/ubuntu.sources


############################################################
# make sure that pending and the PPA are higher priority
############################################################

# this may not be needed. remove comment if it is
#COPY containers/rocm-test-priorities.apt.conf /etc/apt/preferences.d/00-rocm-testing-repo-priorities

############################################################
# update and install base system
############################################################
RUN echo "updating apt metadata"; apt-get update
RUN echo "upgrading"; apt-get upgrade -y
RUN echo "installing base utils"; apt-get install -y git vim bash ubuntu-dbgsym-keyring

############################################################
# enable ubuntu archive debug repos
############################################################

COPY resolute-ddebs.list /etc/apt/sources.list.d/ddebs.sources
RUN echo "updating apt metadata with debug"; apt-get update

############################################################
# just install base tools
############################################################

RUN echo "installing base tools"; apt-get install -y rocminfo gdb tmt testrig

############################################################
# add root to render and video groups for DRM access
############################################################

RUN usermod -a -G video root

############################################################
# clean metadata to keep size down
############################################################

RUN echo "cleaning apt metadata"; apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/bash"]

