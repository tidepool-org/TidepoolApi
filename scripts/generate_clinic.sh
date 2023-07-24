#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {source-spec-filename} {bundled-spec-filename}"
		;;

    -i | --install)
		trace npm --version
		trace npm install -g @apidevtools/swagger-cli@4.0.4
		trace go version
		trace go install github.com/deepmap/oapi-codegen/cmd/oapi-codegen@latest
        exit 0
        ;;

    -c | --self-check)
        trace swagger-cli --version
        trace oapi-codegen --version
        exit 0
        ;;

    *)
        source=$1
		bundled=$2
        server=$(dirname $bundled)/server
        client=$(dirname $bundled)/client
        common="--old-config-style --exclude-tags=Confirmations --package=api"
		trace swagger-cli bundle $source -o $bundled -t yaml
        trace mkdir -p $server $client
		trace oapi-codegen $common --generate=server -o $server/gen_server.go $bundled
		trace oapi-codegen $common --generate=spec -o $server/gen_spec.go $bundled
		trace oapi-codegen $common --generate=types -o $server/gen_types.go $bundled
        trace oapi-codegen $common --generate=types -o $client/types.go $bundled
	    trace oapi-codegen $common --generate=client -o $client/client.go $bundled
esac
