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
    --help)
	echo "usage: $(basename "$0") [-h | --help] | [-i | --install] | [-c | --self-check] | {directory} {token}"
	;;

    --self-check)
	trace stoplight --version
	exit 0
	;;

    *)
	dir=${1?:directory is required}
	token=${2?:token is required}
	# find $1 -maxdepth 1 \( \( -type l -and -iname '*.yaml' \) -or -iname 'openapi*.json' \) -print -delete
	trace stoplight push --directory "$dir" --ci-token "$token"
esac
