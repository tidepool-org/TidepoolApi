#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ $OSTYPE =~ darwin ]] && command -v grealpath &> /dev/null; then
  TOOLS_BIN=$(grealpath --canonicalize-existing "$SCRIPT_DIR/../tools/bin")
  NPM_BIN=$(grealpath --canonicalize-existing "$SCRIPT_DIR/../node_modules/.bin")
else
  TOOLS_BIN=$(realpath --canonicalize-existing "$SCRIPT_DIR/../tools/bin")
  NPM_BIN=$(realpath --canonicalize-existing "$SCRIPT_DIR/../node_modules/.bin")
fi
PATH=$TOOLS_BIN:$NPM_BIN:$PATH

trace() {
	if [ "${QUIET:-}" = "true" ]; then
        output=$(echo "${PS4}$*" && "$@" 2>&1) || ( echo "${output}" && exit 1 )
	else
		echo "${PS4}$*"
		"$@"
	fi
}

case $1 in
    -h | --help)
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {spec-filename}"
	;;

    -c | --self-check)
	trace spectral --version
	trace redocly --version
	;;

    *)
	spec=${1?:spec-filename is required}
	trace spectral lint --quiet "$spec"
	REDOCLY_SUPPRESS_UPDATE_NOTICE="true" trace redocly lint --format=codeframe "$spec"
esac
