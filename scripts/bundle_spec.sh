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
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {source-spec} {bundle-spec}"
	;;

    -c | --self-check)
	trace redocly --version
	;;

    *)
	source=${1?:source-spec is required}
	bundle=${2?:bundle-spec is required}
	trace redocly bundle "$source" --output "$bundle"
esac
