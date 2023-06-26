#!/bin/sh -e

trace() {
    echo + $*
    $*
}

case $1 in
	-h | --help)
		echo "usage: $(basename $0) [-h | --help] | [-i | --install] | {source} {destination}"
		;;

    -i | --install)
        trace npm --version
        trace npm install --location=global @openapi-contrib/json-schema-to-openapi-schema@2.2.5
        exit 0
        ;;

    *)
        SOURCE=$1
        DESTINATION=$2
        find $SOURCE -depth -name "*.json" -print0 | while read -d $'\0' file
        do
            dst=${file%".json"}.yaml
            dst="$DESTINATION"${dst#"$SOURCE"}
            mkdir -p $(dirname $dst)
            echo converting $file
            json-schema-to-openapi-schema convert $file | yq -P > $dst
        done
esac
