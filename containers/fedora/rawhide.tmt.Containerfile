# Copyright Advanced Micro Devices, Inc.
#
# SPDX-License-Identifier: MIT

FROM fedora-rocm-test-base
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"

# 20250619 - tmt is borked in rawhide, will need to hack at its install until it's deps are working with python 3.14
RUN echo "Install test requirements"; dnf -y install dnf-plugins-core beakerlib cmake

RUN echo "Install bits needed for tmt"; dnf -y install python3.13-devel gcc rsync

RUN mkdir /opt/localtesting
RUN python3.13 -m venv /opt/localtesting/env_tmt
RUN source /opt/localtesting/env_tmt/bin/activate && python -m pip install tmt && deactivate

CMD ["/usr/bin/bash"]

