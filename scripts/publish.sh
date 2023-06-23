#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	--help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {folder} {token}"
		;;

    --install)
		trace npm --version
		trace npm install -g @stoplight/cli@6.0.1280
        exit 0
        ;;

    --self-check)
        trace stoplight --version
        exit 0
        ;;

    *)
		find $1 -maxdepth 1 \( \( -type l -and -iname '*.yaml' \) -or -iname 'openapi*.json' \) -print -delete
		trace stoplight push --directory $1 --ci-token $2
esac
