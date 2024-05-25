#!/bin/sh

VERSION=$(head -1 debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

echo ${VERSION}
echo ${VERSION_BASE}

if [ -f lammps-${VERSION_BASE}.tar.gz ]; then
  exit 127
fi

wget http://deb.debian.org/debian/pool/main/l/lammps/lammps_${VERSION_BASE}.orig.tar.xz
xz -d lammps_${VERSION_BASE}.orig.tar.xz
gzip lammps_${VERSION_BASE}.orig.tar
