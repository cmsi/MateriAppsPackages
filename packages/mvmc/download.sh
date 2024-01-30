#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f mvmc-$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://github.com/issp-center-dev/mVMC/releases/download/v${VERSION_BASE}/mVMC-${VERSION_BASE}.tar.gz
mkdir mvmc-${VERSION_BASE}
tar zxvf mVMC-${VERSION_BASE}.tar.gz -C mvmc-${VERSION_BASE} --strip-component=1
tar zcvf mvmc_${VERSION_BASE}.orig.tar.gz mvmc-${VERSION_BASE}
rm -rf mvmc-${VERSION_BASE} mVMC-${VERSION_BASE}.tar.gz
