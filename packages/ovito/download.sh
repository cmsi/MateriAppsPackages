#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f ovito_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
wget https://gitlab.com/stuko/ovito/-/archive/v$VERSION_BASE/ovito-v$VERSION_BASE.tar.gz
tar zxvf ovito-v$VERSION_BASE.tar.gz
mv -f ovito-v$VERSION_BASE ovito-$VERSION_BASE
tar zcvf ovito_$VERSION_BASE.orig.tar.gz ovito-$VERSION_BASE
rm -rf ovito-$VERSION_BASE ovito-v$VERSION_BASE.tar.gz
