#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f hphi-${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget https://github.com/issp-center-dev/HPhi/releases/download/v${VERSION_BASE}/HPhi-${VERSION_BASE}.tar.gz
tar zxvf HPhi-${VERSION_BASE}.tar.gz
mv -f HPhi-${VERSION_BASE} hphi-${VERSION_BASE}
tar zcvf hphi_${VERSION_BASE}.orig.tar.gz hphi-${VERSION_BASE}
rm -rf hphi-${VERSION_BASE} HPhi-${VERSION_BASE}.tar.gz
