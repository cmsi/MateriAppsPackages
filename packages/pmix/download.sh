#!/bin/sh

SCRIPT_DIR=$(cd $(dirname ${0}) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g' | cut -d '-' -f 1)
VERSION_BASE=$(echo ${VERSION} | sed s/+ma//g)

curl -L https://github.com/openpmix/openpmix/releases/download/v"$VERSION_BASE"/pmix-"$VERSION_BASE".tar.gz -O
tar zxvf pmix-"$VERSION_BASE".tar.gz
mv pmix-${VERSION_BASE} pmix-${VERSION}
tar zcvf pmix_${VERSION}.orig.tar.gz pmix-${VERSION}
rm -rf pmix-${VERSION} pmix-"$VERSION_BASE".tar.gz
