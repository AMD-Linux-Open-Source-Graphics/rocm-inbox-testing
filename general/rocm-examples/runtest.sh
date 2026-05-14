#!/bin/bash
# vim: dict=/usr/share/beakerlib/dictionary.vim cpt=.,w,b,u,t,i,k
#
# Run the upstream testsuite for rocfft
#

setup() {
    load "../../support/test_helper/bats-support/load"
    load "../../support/test_helper/bats-assert/load"

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
}

@test "gather rocminfo" {
    run bats_pipe rocminfo \| tee recorded_rocminfo
}

## include beakerlib
#. /usr/share/beakerlib/beakerlib.sh
#
#PACKAGE='rocm-examples'
#
#rlJournalStart
#    rlPhaseStart FAIL rocminfo
#        rlRun -s "rocminfo" 0 "gathering rocminfo"
#    rlPhaseEnd
#
#    rlPhaseStartSetup
#        # only run dnf install if user is root
#        if [ "$EUID" -ne 0 ]
#        then
#            echo "Not running test as root, skipping package install and assuming that required packages are already installed"
#        else
#            rlRun "dnf -y install $PACKAGE"
#        fi
#
#        # make sure that the package is available
#        rlAssertRpm "$PACKAGE"
#
#    rlPhaseEnd
#
#    rlPhaseStart FAIL runTests
#
#        mkdir test_output
#
#        cat "test-binary-list" | while read -r BINARY_NAME; do
#            rlRun "$BINARY_NAME > test_output/$BINARY_NAME-output"
#        done
#        #rlAssertExists "rocfft-test-output.xml"
#
#    rlPhaseEnd
#
#rlJournalPrintText
#rlJournalEnd
