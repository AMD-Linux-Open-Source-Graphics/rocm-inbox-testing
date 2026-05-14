# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM ubuntu:resolute
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"


############################################################
# enable any extra repos
############################################################

# these repos are ppas that tend to contain pre-release rocm pacakges. enable if needed
#COPY containers/bullwinkle-team-ubuntu-rocm-devel-resolute.sources /etc/apt/sources.list.d/bullwinkle-team-ubuntu-rocm-devel-resolute.sources
#COPY containers/bullwinkle-team-ubuntu-rocm-devel-21-resolute.sources /etc/apt/sources.list.d/bullwinkle-team-ubuntu-rocm-devel-21-resolute.sources

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

COPY containers/resolute-ddebs.list /etc/apt/sources.list.d/ddebs.sources
RUN echo "updating apt metadata with debug"; apt-get update

############################################################
# just install rocminfo, any other test packages will be installed later
############################################################

RUN echo "installing rocm tools"; apt-get install -y rocminfo

############################################################
# clean metadata to keep size down
############################################################

RUN echo "cleaning apt metadata"; apt-get clean

CMD ["/usr/bin/bash"]

