#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f triqs-${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget https://github.com/TRIQS/triqs/releases/download/${VERSION_BASE}/triqs-${VERSION_BASE}.tar.gz
mkdir triqs-${VERSION_BASE}
tar zxvf triqs-${VERSION_BASE}.tar.gz -C triqs-${VERSION_BASE} --strip-component=1
tar zcvf triqs_${VERSION_BASE}.orig.tar.gz triqs-${VERSION_BASE}
rm -rf triqs-${VERSION_BASE} triqs-${VERSION_BASE}.tar.gz
