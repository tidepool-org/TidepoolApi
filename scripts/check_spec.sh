#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TOOLS_BIN=$(realpath --canonicalize-existing "$SCRIPT_DIR/../tools/bin")
NPM_BIN=$(realpath --canonicalize-existing "$SCRIPT_DIR/../node_modules/.bin")
PATH=$TOOLS_BIN:$NPM_BIN:$PATH

trace() {
    echo "${PS4}$*"
    "$@"
}

case $1 in
    -h | --help)
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {spec-filename}"
	;;

    -c | --self-check)
	trace spectral --version
	trace swagger-cli --version
	trace redocly --version
	;;

    *)
	spec=${1?:spec-filename is required}
	trace swagger-cli validate "$spec"
	trace spectral lint --quiet "$spec"
	trace redocly lint --format=codeframe "$spec"
esac
