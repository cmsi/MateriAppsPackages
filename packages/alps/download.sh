#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/2://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)
echo $VERSION $VERSION_BASE

if [ -f alps_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

rm -rf alps-${VERSION_BASE} v${VERSION_BASE}.tar.gz
wget https://github.com/ALPSim/ALPS/archive/refs/tags/v${VERSION_BASE}.tar.gz
mkdir alps-${VERSION_BASE}
tar zxvf v${VERSION_BASE}.tar.gz --strip-components=1 -C alps-${VERSION_BASE}
tar zcvf alps_${VERSION_BASE}.orig.tar.gz alps-${VERSION_BASE}
rm -rf alps-${VERSION_BASE} v${VERSION_BASE}.tar.gz
