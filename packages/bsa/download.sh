#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

if [ -f bsa-$VERSION_BASE.orig.tar.gz ]; then
  exit 127
fi
case ${VERSION_BASE} in
  20151218 ) ID=eb06870e0386f310621e3116b8c7a77c734e79a4 ;;
  20211226 ) ID=aaaca0146509236d179bcbc7efd3851c91a2b0b4 ;;
esac
wget https://github.com/KenjiHarada/BSA/archive/${ID}.tar.gz -O - | tar zxf -
mv BSA-${ID} bsa-${VERSION_BASE}
tar zcvf bsa_$VERSION_BASE.orig.tar.gz bsa-$VERSION_BASE
rm -rf bsa-$VERSION_BASE HPhi-$VERSION_BASE.tar.gz
