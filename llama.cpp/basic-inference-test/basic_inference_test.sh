#! /usr/bin/bash

set -e

################################################################################
# This is a _very_ trivial test case to poke at llama.cpp but there are a lot of
# cases which aren't handled.
#
# This test case should be replaced as soon as possible for something with a
# better feature set that does things like check the output for reasonable-ness
################################################################################

apt-get install -y llama.cpp libggml0-backend-hip

llama-cli -st -hf ggml-org/gemma-3-1b-it-GGUF -p "If this is working, please output the exact phrase 'this appears to be working'"

exit
