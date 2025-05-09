#!/bin/sh

PACKAGE_DIR=$(cd "$(dirname "$0")" && pwd)
PACKAGE=$(basename "$PACKAGE_DIR")
REPOSITORY=https://github.com/issp-center-dev/ChiQ

# shellcheck disable=SC1091
. "$PACKAGE_DIR"/../../script/path.sh

VERSION_ARCHIVE=$(echo "$VERSION_BASE" | sed 's/b/-beta/g')

if [ -f "$PACKAGE"_"$VERSION_BASE".orig.tar.gz ]; then
  exit 127
fi
rm -rf "$PACKAGE"-"$VERSION_BASE"
mkdir -p "$PACKAGE"-"$VERSION_BASE"
wget -O - "$REPOSITORY"/archive/refs/tags/v"$VERSION_ARCHIVE".tar.gz | tar zxvf - -C "$PACKAGE"-"$VERSION_BASE" --strip-components=1
tar zcvf "$PACKAGE"_"$VERSION_BASE".orig.tar.gz "$PACKAGE"-"$VERSION_BASE"
rm -rf "$PACKAGE"-"$VERSION_BASE"
