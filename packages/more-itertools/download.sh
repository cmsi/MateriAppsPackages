#!/bin/sh

PACKAGE_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGE=$(basename "$PACKAGE_DIR")
REPOSITORY=https://github.com/more-itertools/more-itertools

# shellcheck disable=SC1091
. "$PACKAGE_DIR"/../../script/path.sh

if [ -f "$PACKAGE"_"$VERSION_BASE".orig.tar.gz ]; then
  exit 127
fi
rm -rf "$PACKAGE"-"$VERSION_BASE"
mkdir -p "$PACKAGE"-"$VERSION_BASE"
wget -O - "$REPOSITORY"/releases/download/v"$VERSION_BASE"/more_itertools-"$VERSION_BASE".tar.gz | tar zxvf - -C "$PACKAGE"-"$VERSION_BASE" --strip-components=1
tar zcvf "$PACKAGE"_"$VERSION_BASE".orig.tar.gz "$PACKAGE"-"$VERSION_BASE"
rm -rf "$PACKAGE"-"$VERSION_BASE"
