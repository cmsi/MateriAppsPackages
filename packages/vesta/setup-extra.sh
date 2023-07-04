#!/bin/sh

PACKAGE="vesta"
PACKAGE_DIR=$(cd $(dirname $0) && pwd)

. ${PACKAGE_DIR}/../../script/path.sh

BASE_URL=https://jp-minerals.org/vesta/archives
wget -O - ${BASE_URL}/${VERSION_BASE}/VESTA-gtk3.tar.bz2 | tar jxf -
mv -f VESTA-gtk3 dist
