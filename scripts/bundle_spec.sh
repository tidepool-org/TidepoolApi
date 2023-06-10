#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {source-spec} {bundle-spec}"
		;;

    -i | --install)
        trace npm install --location=global @redocly/cli@1.0.0-beta.128
        exit 0
        ;;

    -c | --self-check)
        trace redocly --version
        exit 0
        ;;

    *)
		trace redocly bundle $1 --output $2
esac
