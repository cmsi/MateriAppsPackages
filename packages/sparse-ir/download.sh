#!/bin/sh

PACKAGE=sparse-ir
PACKAGE_DIR=$(cd "$(dirname "$0")" && pwd)

# shellcheck disable=SC1091
. "$PACKAGE_DIR"/../../script/path.sh

if [ -f "$PACKAGE"_"$VERSION_BASE".orig.tar.gz ]; then
  exit 127
fi
rm -rf "$PACKAGE"-"$VERSION_BASE"
mkdir -p "$PACKAGE"-"$VERSION_BASE"
wget -O - https://github.com/SpM-lab/sparse-ir/archive/refs/tags/v"$VERSION_BASE".tar.gz | tar zxvf - -C "$PACKAGE"-"$VERSION_BASE" --strip-components=1
tar zcvf "$PACKAGE"_"$VERSION_BASE".orig.tar.gz "$PACKAGE"-"$VERSION_BASE"
rm -rf "$PACKAGE"-"$VERSION_BASE"
