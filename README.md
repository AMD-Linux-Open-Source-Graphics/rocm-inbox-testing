# ROCm Testing

This repository contains tests meant for ROCm packages in Linux distros.


## Requirements

In order to run the tests in this repository, the following tools are required in addition to the dependencies of the individual tests:

 * [tmt](https://github.com/teemtee/tmt)
 * [fmf](https://github.com/teemtee/fmf)
 * [testrig](https://github.com/AMD-Linux-Open-Source-Graphics/testrig)

## Running tests

These tests **Require** ROCm capable hardware and permission to access that hardware to pass. Running the tests in a VM is currently not supported nor is it expected to pass.

The tests can be run inside a container that has access to appropriate hardware. For podman, this could look like:

```
podman run --rm -it --privileged --device /dev/kfd --device /dev/dri --security-opt label=disable --group-add keep-groups ubuntu:resolute
```

To run the tests directly, use `tmt`
```
tmt run test -f tag:selftests provision -h local --feeling-safe discover -h fmf execute -h tmt
```

To use the included `run_tests.sh` wrapper with a test tag (see `.fmf` files to see the existing tags):
```
ROCMTESTTAG=selftests ./run_tests.sh
```

Run logs will show up in `/var/tmp/tmt`
