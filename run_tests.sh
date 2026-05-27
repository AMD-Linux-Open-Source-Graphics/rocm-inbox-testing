#!/usr/bin/bash

################################################################################
# This is a script that facilitates running the various rocm tests in an
# automated environment. You can run it locally if you want but make sure to
# set the proper env vars
#
# This is intended to be run inside of a container, do not run it on your local
# system without understanding exactly what the tests are doing
################################################################################


# check for ROCMTESTTAG env var to know which tests we're supposed to run
if [ -z $ROCMTESTTAG ];
then
    echo "by default, the entire selftest suite will be run. This can take over 12 hours"
    echo "to run a subset of the suite, set the ENV variable \$ROCMTESTTAG at runtime"
    echo "waiting 5 seconds before starting execution"
    echo ""
    sleep 5
    export ROCMTESTTAG="selftest"
fi

echo "running tests with tag '$ROCMTESTTAG'"
echo ""

if [ ! -f /usr/bin/tmt ];
then
    echo "tmt is not installed. make sure it is installed at /usr/bin/tmt before running this script"
    exit 1
fi

if [ ! -f /usr/bin/testrig ];
then
    echo "testrig is not installed. make sure it is installed at /usr/bin/testrig before running this script"
    exit 1
fi

tmt run test -f tag:$ROCMTESTTAG provision -h local --feeling-safe discover -h fmf execute -h tmt

