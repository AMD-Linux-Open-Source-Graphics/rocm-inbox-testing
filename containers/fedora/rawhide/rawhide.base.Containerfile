# Copyright Advanced Micro Devices, Inc.
# Copyright (c) 2023, 2024 Red Hat, Inc.
#
# SPDX-License-Identifier: MIT

FROM fedora:rawhide
LABEL org.opencontainers.image.authors="Tim.Flink@amd.com"

RUN echo "Install rocm base"; dnf -y install rocminfo
RUN echo "Enable rocm testing COPR"; dnf -y copr enable @rocm-packagers-sig/rocm-test

RUN echo "Install testing tools"; dnf -y install testrig tmt gdb

CMD ["/usr/bin/bash"]

