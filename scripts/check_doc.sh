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
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {doc-filename}"
	;;

    -c | --self-check)
	trace markdownlint --version
	trace markdown-link-check --version
	exit 0
	;;

    *)
	doc="${1?:doc-filename is required}"
	trace markdownlint "$doc"
	trace markdown-link-check "${doc}" --config .markdown-link-check.json
	trace "$(dirname "$0")/check_ref_links.sh" "$doc"
esac
