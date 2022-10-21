#!/bin/sh

PACKAGE=tenes
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f tenes_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/issp-center-dev/TeNeS/releases/download/v${VERSION_BASE}/TeNeS-${VERSION_BASE}.tar.gz
mkdir tenes-${VERSION_BASE}
tar zxvf TeNeS-${VERSION_BASE}.tar.gz -C tenes-${VERSION_BASE} --strip-component=1
tar zcvf tenes_${VERSION_BASE}.orig.tar.gz tenes-${VERSION_BASE}
rm -rf tenes-${VERSION_BASE} TeNeS-${VERSION_BASE}.tar.gz
