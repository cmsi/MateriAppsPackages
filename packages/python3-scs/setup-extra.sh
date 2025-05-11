#!/bin/sh

PACKAGE_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGE=$(basename "$PACKAGE_DIR" | sed s/python3-//g)

# shellcheck disable=SC1091
. "$PACKAGE_DIR"/../../script/path.sh

if [ -d dist ]; then :; else
    pip3 download "$PACKAGE"
    mkdir dist
    unzip "$PACKAGE"*.whl -d dist
    rm -f ./*.whl
    if [ -d dist/$PACKAGE-$VERSION_BASE.dist-info ]; then :; else    
       echo "Error: version mismatch."
       echo "Expected: $PACKAGE-$VERSION_BASE.dist-info"
       echo "Found:    $(ls dist | grep $PACKAGE-*.dist-info)"
       echo "Please check the version in setup.py and try again."
       rm -rf dist
    fi
fi
