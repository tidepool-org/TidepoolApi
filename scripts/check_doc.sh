#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | [-c | --self-check] | {doc-filename}"
		;;

    -i | --install)
        trace npm --version
        trace npm install -g markdownlint-cli@0.33.0
        trace npm install -g markdown-link-check@3.10.3
        exit 0
        ;;

    -c | --self-check)
        trace markdownlint --version
        trace markdown-link-check --version
        exit 0
        ;;

    *)
        trace markdownlint $1
        trace markdown-link-check $1 --config .markdown-link-check.json
        trace $(dirname $0)/check_ref_links.sh $1
esac
