#!/bin/sh

PACKAGE=akaikkr
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

if [ -f cpa2021v02.tgz ]; then :; else
  echo "cpa2021v02.tgz not found"
  exit 127
fi

tar zxf cpa2021v02.tgz
mv cpa2021v02 ${PACKAGE}_$VERSION_BASE
tar zcvf ${PACKAGE}_$VERSION_BASE.orig.tar.gz ${PACKAGE}_$VERSION_BASE
rm -rf ${PACKAGE}_$VERSION_BASE
