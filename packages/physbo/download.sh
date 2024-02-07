#!/bin/sh

SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f physbo_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/issp-center-dev/PHYSBO/archive/refs/tags/v${VERSION_BASE}.tar.gz
tar zxvf v$VERSION_BASE.tar.gz
mv -f PHYSBO-$VERSION_BASE physbo-$VERSION_BASE
tar zcvf physbo_$VERSION_BASE.orig.tar.gz physbo-$VERSION_BASE
rm -rf physbo-$VERSION_BASE v$VERSION_BASE.tar.gz
