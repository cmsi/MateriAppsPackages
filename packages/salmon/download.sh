#!/bin/sh

SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

curl -L http://salmon-tddft.jp/download/SALMON-v.${VERSION_BASE}.tar.gz -O
tar zxvf SALMON-v.${VERSION_BASE}.tar.gz
mv -f SALMON-v.${VERSION_BASE} salmon-${VERSION_BASE}
tar zcvf salmon_${VERSION_BASE}.orig.tar.gz salmon-${VERSION_BASE}
rm -rf salmon-${VERSION_BASE} SALMON-v.${VERSION_BASE}.tar.gz
