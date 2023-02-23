#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {merged-spec-filename}"
		;;

    -i | --install)
		case $(uname -s) in
			Darwin)
                trace brew --version
        		trace brew install jsonnet@0.19.1
                ;;
			Linux)
                trace go version
				trace go install github.com/google/go-jsonnet/cmd/jsonnet@latest
                ;;
		esac
        trace npm install --location=global openapi-merge-cli@1.3.1
        exit 0
        ;;

    -c | --self-check)
        trace jsonnet --version
        trace openapi-merge-cli --version
        exit 0
        ;;

    *)
		trace jsonnet --ext-str excludeTags="$2" \
			--ext-str sourceFolder=./ \
			--ext-str outputFile=$(basename $1) \
			--output-file $(dirname $1)/openapi-merge.json \
			./templates/openapi-merge.jsonnet
        cd $(dirname $1)
        trace openapi-merge-cli
esac
