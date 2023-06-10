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
        trace npm install --location=global @stoplight/spectral-cli@6.6.0
        trace npm install --location=global @apidevtools/swagger-cli@4.0.4
        trace npm install --location=global @redocly/cli@1.0.0-beta.128
        exit 0
        ;;

    -c | --self-check)
        trace spectral --version
        trace swagger-cli --version
        trace redocly --version
        exit 0
        ;;

    *)
        trace swagger-cli validate $1
        trace spectral lint --quiet $1
        trace redocly lint --format=codeframe $1
esac
