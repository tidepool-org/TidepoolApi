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
        trace npm install --location=global @apidevtools/swagger-cli@4.0.4
        exit 0
        ;;

    -c | --self-check)
        trace swagger-cli --version
        exit 0
        ;;

    *)
		trace swagger-cli bundle --type yaml --dereference $1 --outfile $2
esac
