#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

echo ${VERSION}
echo ${VERSION_BASE}

if [ ${VERSION_BASE} = "20240303.stable_2Aug2023_update3" ]; then
  VERSION_DOWNLOAD="2Aug2023-update3"
  VERSION_DOWNLOAD_DIR="stable_2Aug2023_update3"
fi

echo ${VERSION_DOWNLOAD}
echo ${VERSION_DOWNLOAD_DIR}

if [ -f lammps-${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi

wget https://github.com/lammps/lammps/releases/download/${VERSION_DOWNLOAD_DIR}/lammps-src-${VERSION_DOWNLOAD}.tar.gz -O lammps_${VERSION_BASE}.orig.tar.gz
