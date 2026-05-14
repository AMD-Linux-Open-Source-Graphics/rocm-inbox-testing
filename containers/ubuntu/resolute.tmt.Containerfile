# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM resolute-rocm-test-base
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"

RUN echo "update apt metadata"; apt-get update

############################################################
# need cmake for some tests, rocminfo for system info,
# gdb for debugging
############################################################

RUN echo "Install test requirements"; apt-get install -y cmake rocminfo gdb

############################################################
# tmt is not yet packaged, will need to install into venv
############################################################
RUN echo "Install bits needed for tmt"; apt-get install -y python3-dev python3-venv gcc rsync python3-apt

RUN mkdir /opt/localtesting
RUN python3 -m venv --system-site-packages /opt/localtesting/env_tmt

# make sure to use bash, buildah likes to use sh which can't use source
RUN ["/usr/bin/bash", "-c", "source /opt/localtesting/env_tmt/bin/activate && python -m pip install tmt && deactivate"]

############################################################
# testrig is not yet packaged, install from git
############################################################
RUN git clone --branch develop https://github.com/AMD-Linux-Open-Source-Graphics/testrig /opt/localtesting/testrig

# install testrig into the same venv as tmt
RUN ["/usr/bin/bash", "-c", "source /opt/localtesting/env_tmt/bin/activate && cd /opt/localtesting/testrig && python -m pip install . && deactivate"]

############################################################
# install python-click for development purposes
############################################################

#RUN echo "install python3-click"; apt-get install -y python3-click

############################################################
# clean metadata to keep size down?
############################################################

RUN echo "cleaning apt metadata"; apt-get clean

CMD ["/usr/bin/bash"]

