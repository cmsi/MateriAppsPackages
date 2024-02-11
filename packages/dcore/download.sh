#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f dcore-$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/issp-center-dev/DCore/archive/refs/tags/v${VERSION_BASE}.tar.gz
mkdir dcore-${VERSION_BASE}
tar zxvf v${VERSION_BASE}.tar.gz -C dcore-${VERSION_BASE} --strip-component=1
tar zcvf dcore_${VERSION_BASE}.orig.tar.gz dcore-${VERSION_BASE}
rm -rf dcore-${VERSION_BASE} v${VERSION_BASE}.tar.gz
