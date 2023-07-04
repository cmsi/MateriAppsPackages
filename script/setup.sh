#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd $(dirname ${SCRIPT})/.. && pwd)

PACKAGE="$1"
PACKAGE_DIR="${SCRIPT_DIR}/packages/${PACKAGE}"
if [ -z "${PACKAGE}" ]; then
  echo "Usage: ${SCRIPT} package"
  exit 127
fi
if [ -d "${PACKAGE_DIR}" ]; then :; else
  echo "Error: package ${PACKAGE} not found"
  echo "Usage: ${SCRIPT} package"
  exit 127
fi

. ${SCRIPT_DIR}/script/path.sh
test -z "${BUILD_DIR}" && exit 127

RELEASE=$(lsb_release -s -c)
if [ -f ${PACKAGE_DIR}/no-${RELEASE} ]; then
  exit 0
fi

CP="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

set -x
rm -rf ${BUILD_DIR}/${PACKAGE}
mkdir -p ${BUILD_DIR}/${PACKAGE}
cd ${BUILD_DIR}
if [ -f ${PACKAGE_DIR}/no-src ]; then
  if [ -d ${PACKAGE_DIR}/files ]; then
    cp -rp ${PACKAGE_DIR}/files/* ${PACKAGE}
  fi
else
  ${CP} ${DATA_DIR}/src/${PACKAGE}_${VERSION_BASE}.orig.tar.gz .
  tar zxf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz -C ${PACKAGE} --strip-components=1
fi
cd ${PACKAGE}
mkdir -p debian
cp -rp ${PACKAGE_DIR}/debian/* debian/
if [ -d ${PACKAGE_DIR}/debian-${RELEASE} ]; then
  cp -rp ${PACKAGE_DIR}/debian-${RELEASE}/* debian/
fi
sudo apt-get update
sudo apt-get -y upgrade
dpkg-checkbuilddeps 2>&1 | sed 's/dpkg-checkbuilddeps.*dependencies: //' | sudo xargs apt-get -y install
if [ -f ${PACKAGE_DIR}/setup-extra.sh ]; then
  sh ${PACKAGE_DIR}/setup-extra.sh
fi
