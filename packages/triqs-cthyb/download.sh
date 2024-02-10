#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

NAME="cthyb"
PACKAGE="triqs-${NAME}"

if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget https://github.com/TRIQS/${NAME}/releases/download/${VERSION_BASE}/${NAME}-${VERSION_BASE}.tar.gz
mkdir ${PACKAGE}-${VERSION_BASE}
tar zxvf ${NAME}-${VERSION_BASE}.tar.gz -C ${PACKAGE}-${VERSION_BASE} --strip-component=1
tar zcvf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ${PACKAGE}-${VERSION_BASE}
rm -rf ${PACKAGE}-${VERSION_BASE} ${NAME}-${VERSION_BASE}.tar.gz
