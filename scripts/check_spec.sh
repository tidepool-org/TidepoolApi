#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {spec-filename}"
		;;

    -i | --install)
        trace npm --version
        trace npm install -g @stoplight/spectral-cli@6.6.0
        trace npm install -g @apidevtools/swagger-cli@4.0.4
        exit 0
        ;;

    -c | --self-check)
        trace spectral --version
        trace swagger-cli --version
        exit 0
        ;;

    *)
        if [ "$(dirname $1)" = "$(dirname $1 | cut -d/ -f1)" ]; then
            trace swagger-cli validate $1
            trace spectral lint --quiet $1
        else
            trace spectral lint --quiet --ignore-unknown-format $1
        fi
esac
