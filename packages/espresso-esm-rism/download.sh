#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f espresso-esm-rism_$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
curl -L -O https://gitlab.com/minoru-otani/q-e/-/archive/rism_expand_oneside/q-e-rism_expand_oneside.tar.bz2
tar jxvf q-e-rism_expand_oneside.tar.bz2
mv -f q-e-rism_expand_oneside espresso-esm-rism-$VERSION_BASE
tar zcvf espresso-esm-rism_$VERSION_BASE.orig.tar.gz espresso-esm-rism-$VERSION_BASE
rm -rf espresso-esm-rism-$VERSION_BASE q-e-rism_expand_oneside.tar.bz2
