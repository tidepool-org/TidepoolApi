#!/usr/bin/env bash

set -eou pipefail

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
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {merged-spec-filename}"
	;;

    -c | --self-check)
	trace jsonnet --version
	trace openapi-merge-cli --version
	;;

    *)
	spec=${1?:merged-spec-filename is required}
	excluded=${2:-}
	trace jsonnet --ext-str excludeTags="$excluded" \
	      --ext-str sourceFolder=./ \
	      --ext-str outputFile="$(basename "$spec")" \
	      --output-file "$(dirname "$spec")/openapi-merge.json" \
	      ./templates/openapi-merge.jsonnet
	trace cd "$(dirname "$spec")"
	trace openapi-merge-cli 2>&1 | awk '{ print $0 } /exception/ { exit 1 }'
esac
