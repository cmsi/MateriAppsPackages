#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f fermisurfer_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

rm -rf fermisurfer-${VERSION_BASE}
wget https://github.com/mitsuaki1987/fermisurfer/archive/refs/tags/${VERSION_BASE}.tar.gz
mkdir -p fermisurfer-${VERSION_BASE}
tar zxvf ${VERSION_BASE}.tar.gz -C fermisurfer-${VERSION_BASE} --strip-components=1
tar zcvf fermisurfer_${VERSION_BASE}.orig.tar.gz --exclude ".DS_Store" fermisurfer-${VERSION_BASE} 
rm -rf fermisurfer-${VERSION_BASE} ${VERSION_BASE}.tar.gz
