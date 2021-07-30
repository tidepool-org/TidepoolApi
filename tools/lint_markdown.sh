#!/bin/sh
set -x
cd $(dirname $(realpath $0))/..
markdownlint './docs/**/*.md'
