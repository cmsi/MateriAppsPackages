#!/bin/sh

PACKAGE_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGE=$(basename "$PACKAGE_DIR")
REPOSITORY=https://github.com/bodono/scs-python

# shellcheck disable=SC1091
. "$PACKAGE_DIR"/../../script/path.sh

VERSION_ARCHIVE=$(echo "$VERSION_BASE" | sed 's/3.2.y/3.2.7.post2/g')

if [ -f "$PACKAGE"_"$VERSION_BASE".orig.tar.gz ]; then
  exit 127
fi
rm -rf "$PACKAGE"-"$VERSION_BASE"
mkdir -p "$PACKAGE"-"$VERSION_BASE"
wget -O - "$REPOSITORY"/archive/refs/tags/"$VERSION_ARCHIVE".tar.gz | tar zxvf - -C "$PACKAGE"-"$VERSION_BASE" --strip-components=1
tar zcvf "$PACKAGE"_"$VERSION_BASE".orig.tar.gz "$PACKAGE"-"$VERSION_BASE"
rm -rf "$PACKAGE"-"$VERSION_BASE"
