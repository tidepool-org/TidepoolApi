#!/bin/sh -e

echo "checking \$ref links in $1:"
awk '/\$ref:/ { print $2 }' $1 | xargs -I% sh -c "cd $(dirname $1); ls -1 %"
