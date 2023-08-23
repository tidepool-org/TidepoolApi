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

case "$1" in
    -h | --help)
	echo "usage: $(basename "$0") [-h | --help] | {source} {destination}"
	;;

    *)
	SOURCE=${1?:source is required}
	DESTINATION=${2?:destination is required}
	find "$SOURCE" -depth -name "*.json" -print0 | while read -d $'\0' file
	do
	    dst=${file%".json"}.yaml
	    dst="$DESTINATION"${dst#"$SOURCE"}
	    mkdir -p "$(dirname "$dst")"
	    echo "converting $file"
	    json-schema-to-openapi-schema convert "$file" | yq -P > "$dst"
	done
esac
