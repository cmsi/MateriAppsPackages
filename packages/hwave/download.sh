#!/bin/sh

PACKAGE=hwave
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/issp-center-dev/H-wave/archive/refs/tags/v${VERSION_BASE}.tar.gz
mkdir ${PACKAGE}-${VERSION_BASE}
tar zxvf v${VERSION_BASE}.tar.gz -C ${PACKAGE}-${VERSION_BASE} --strip-component=1
tar zcvf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ${PACKAGE}-${VERSION_BASE}
rm -rf ${PACKAGE}-${VERSION_BASE} v${VERSION_BASE}.tar.gz