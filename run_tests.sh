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
    echo "the ENV variable \$ROCMTESTTAG must be set"
    exit 1
fi

echo "running tests with tag '$ROCMTESTTAG'"

# HACK - tmt isn't installable with python 3.14 right now, this will need to be removed later
source /opt/localtesting/env_tmt/bin/activate

tmt run test -f tag:$ROCMTESTTAG provision -h local --feeling-safe discover -h fmf execute -h tmt

deactivate
