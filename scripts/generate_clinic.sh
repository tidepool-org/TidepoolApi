#!/usr/bin/env bash

set -eou pipefail

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
    echo "${PS4}$*"
    "$@"
}

case $1 in
    -h | --help)
	echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {source-spec-filename} {bundled-spec-filename}"
	;;

    -c | --self-check)
	trace redocly --version
	trace oapi-codegen --version
	;;

    *)
	source=${1?:source-spec-filename is required}
	bundled=${2?:bundled-spec-filename is required}
	server="$(dirname "$bundled")/server"
	client="$(dirname "$bundled")/client"
	common=( --old-config-style --exclude-tags=Confirmations --package=api )
	trace redocly bundle "$source" -o "$bundled"
	trace mkdir -p "$server" "$client"
	trace oapi-codegen "${common[@]}" --generate=server -o "$server/gen_server.go" "$bundled"
	trace oapi-codegen "${common[@]}" --generate=spec -o "$server/gen_spec.go" "$bundled"
	trace oapi-codegen "${common[@]}" --generate=types -o "$server/gen_types.go" "$bundled"
	trace oapi-codegen "${common[@]}" --generate=types -o "$client/types.go" "$bundled"
	trace oapi-codegen "${common[@]}" --generate=client -o "$client/client.go" "$bundled"
esac
