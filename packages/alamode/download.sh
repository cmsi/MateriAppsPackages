#!/bin/sh

PACKAGE=alamode
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget -O ${PACKAGE}-${VERSION_BASE}.tar.gz https://sourceforge.net/projects/alamode/files/v.1.5.0/v.1.5.0%20source%20code.tar.gz/download
rm -rf ${PACKAGE}-${VERSION_BASE} && mkdir ${PACKAGE}-${VERSION_BASE}
tar zxvf ${PACKAGE}-${VERSION_BASE}.tar.gz -C ${PACKAGE}-${VERSION_BASE} --strip-component=1
tar zcvf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ${PACKAGE}-${VERSION_BASE}
rm -rf ${PACKAGE}-${VERSION_BASE} ${PACKAGE}-${VERSION_BASE}.tar.gz
