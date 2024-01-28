#!/bin/sh

PACKAGE=cif2cell
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f cif2cell_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/torbjornbjorkman/cif2cell/archive/refs/tags/$VERSION_BASE.tar.gz
tar zxvf $VERSION_BASE.tar.gz
mv -f $VERSION_BASE cif2cell-$VERSION_BASE
tar zcvf cif2cell_$VERSION_BASE.orig.tar.gz cif2cell-$VERSION_BASE
rm -rf cif2cell-$VERSION_BASE $VERSION_BASE.tar.gz
