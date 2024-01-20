#!/bin/sh

PACKAGE=openmx
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget https://github.com/OrderN/CONQUEST-release/releases/download/v${VERSION_BASE}/CONQUEST-release-${VERSION_BASE}.tar.gz
tar zxvf CONQUEST-release-${VERSION_BASE}.tar.gz
mv CONQUEST-release-${VERSION_BASE} conquest-${VERSION_BASE}
tar zcvf conquest_${VERSION_BASE}.orig.tar.gz conquest-${VERSION_BASE}
rm -rf CONQUEST-release-${VERSION_BASE}.tar.gz conquest-${VERSION_BASE}
