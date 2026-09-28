#!/usr/bin/env bash

set -eou pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
REALPATH=realpath
if command -v grealpath &>/dev/null; then
    REALPATH=grealpath
fi
TOOLS_BIN=$($REALPATH --canonicalize-missing "$SCRIPT_DIR/../tools/bin")
NPM_BIN=$($REALPATH --canonicalize-missing "$SCRIPT_DIR/../node_modules/.bin")

# Use the oapi-codegen and redocly installed by the Makefile, never
# one from the global $PATH.
OAPI_CODEGEN=$TOOLS_BIN/oapi-codegen
REDOCLY=$NPM_BIN/redocly

# Install the Makefile-pinned versions of the tools. A no-op when they
# are already installed and up to date.
ensure_tools() {
    make --silent --directory "$SCRIPT_DIR/.." \
        tools/bin/oapi-codegen node_modules/.bin/redocly
}

trace() {
    if [ "${QUIET:-}" = "true" ]; then
        output=$(echo "${PS4}$*" && "$@" 2>&1) || (echo "${output}" && exit 1)
    else
        echo "${PS4}$*"
        "$@"
    fi
}

case $1 in
-h | --help)
    echo "usage: $(basename "$0") [-h | --help] | [-c | --self-check] | {source-spec-filename} {bundled-spec-filename}"
    ;;

-c | --self-check)
    ensure_tools
    trace "$REDOCLY" --version
    trace "$OAPI_CODEGEN" --version
    ;;

*)
    source=${1?:source-spec-filename is required}
    bundled=${2?:bundled-spec-filename is required}
    server="$(dirname "$bundled")/server"
    client="$(dirname "$bundled")/client"
    common=(--old-config-style --exclude-tags=Confirmations --package=api)
    ensure_tools
    REDOCLY_SUPPRESS_UPDATE_NOTICE="true" trace "$REDOCLY" bundle "$source" -o "$bundled"
    mkdir -p "$server" "$client"
    trace "$OAPI_CODEGEN" "${common[@]}" --generate=server -o "$server/gen_server.go" "$bundled"
    trace "$OAPI_CODEGEN" "${common[@]}" --generate=spec -o "$server/gen_spec.go" "$bundled"
    trace "$OAPI_CODEGEN" "${common[@]}" --generate=types -o "$server/gen_types.go" "$bundled"
    trace "$OAPI_CODEGEN" "${common[@]}" --generate=types -o "$client/types.go" "$bundled"
    trace "$OAPI_CODEGEN" "${common[@]}" --generate=client -o "$client/client.go" "$bundled"
    ;;
esac
