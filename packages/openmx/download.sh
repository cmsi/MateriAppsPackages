#!/bin/sh

PACKAGE=openmx
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f ${PACKAGE}-${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

VERSION_MM=$(echo ${VERSION_BASE} | cut -d . -f 1,2)
if [ ${VERSION_BASE} = "3.9.9" ]; then
  VERSION_DATE="21Oct17"
fi
wget http://t-ozaki.issp.u-tokyo.ac.jp/${PACKAGE}${VERSION_MM}.tar.gz
wget http://www.openmx-square.org/bugfixed/${VERSION_DATE}/patch${VERSION_BASE}.tar.gz

tar zxvf ${PACKAGE}${VERSION_MM}.tar.gz
mv ${PACKAGE}${VERSION_MM} ${PACKAGE}-${VERSION_BASE}
(cd ${PACKAGE}-${VERSION_BASE}/source; tar zxvf ../../patch${VERSION_BASE}.tar.gz)
(cd ${PACKAGE}-${VERSION_BASE}; find . -type f | xargs chmod -x)
tar zcvf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ${PACKAGE}-${VERSION_BASE}
rm -rf ${PACKAGE}-${VERSION_BASE} ${PACKAGE}${VERSION_MM}.tar.gz patch${VERSION_BASE}.tar.gz
