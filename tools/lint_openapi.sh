#!/bin/sh
set -x
cd $(dirname $(realpath $0))/..
# if we pass *.yaml directly to spectral lint, it seems to mix all the files together
# hence the xargs
ls ./reference/*.yaml | xargs -n1 -t spectral lint --verbose
