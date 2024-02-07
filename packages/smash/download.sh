#!/bin/sh

SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f smash_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
        
wget https://sourceforge.net/projects/smash-qc/files/smash-${VERSION_BASE}.tgz
tar zxvf smash-${VERSION_BASE}.tgz
mv smash smash-${VERSION_BASE}
tar zcvf smash_${VERSION_BASE}.orig.tar.gz smash-${VERSION_BASE}
rm -rf smash-${VERSION_BASE} smash-${VERSION_BASE}.tgz
