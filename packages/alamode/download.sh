#!/bin/sh

PACKAGE=alamode
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

VERSION_DATE=
if [ ${VERSION_BASE} = 1.4.2 ]; then
  VERSION_DATE="2022-09-28"
fi

if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget -O ${PACKAGE}-${VERSION_BASE}.tar.gz https://sourceforge.net/projects/${PACKAGE}/files/v.${VERSION_BASE}/ALAMODE%20version%20${VERSION_BASE}%20%28${VERSION_DATE}%29.tar.gz
# wget -O alamode-${VERSION_BASE}.tar.gz https://sourceforge.net/projects/alamode/files/v.${VERSION_BASE}/ALAMODE%20version%20${VERSION_BASE}%20%28${VERSION_DATE}%29.tar.gz
rm -rf ${PACKAGE}-${VERSION_BASE} && mkdir ${PACKAGE}-${VERSION_BASE}
tar zxvf ${PACKAGE}-${VERSION_BASE}.tar.gz -C ${PACKAGE}-${VERSION_BASE} --strip-component=1
tar zcvf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ${PACKAGE}-${VERSION_BASE}
rm -rf ${PACKAGE}-${VERSION_BASE} ${PACKAGE}-${VERSION_BASE}.tar.gz
