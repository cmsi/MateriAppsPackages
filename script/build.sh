#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd $(dirname ${SCRIPT})/.. && pwd)

export PACKAGE="$1"
export PACKAGE_DIR="${SCRIPT_DIR}/packages/${PACKAGE}"
if [ -z "${PACKAGE}" ]; then
  echo "Usage: ${SCRIPT} package"
  exit 127
fi

if [ -d "${PACKAGE_DIR}" ]; then :; else
  echo "Error: ${PACKAGE_DIR} not found"
  echo "Usage: ${SCRIPT} package"
  exit 127
fi

. ${SCRIPT_DIR}/script/path.sh
test -z ${BUILD_DIR} && exit 127

RELEASE=$(lsb_release -s -c)
if [ -f ${PACKAGE_DIR}/no-${RELEASE} ]; then
  exit 0
fi

CP="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

set -x
cd ${BUILD_DIR}/${PACKAGE}
ARCH=$(dpkg --print-architecture)
case ${ARCH} in
  amd64)
    if [ ${MA_INCLUDE_SOURCE} = 1 ]; then
      dpkg-buildpackage -us -uc -sa
    else
      dpkg-buildpackage -us -uc
    fi
    ;;
  *)
    dpkg-buildpackage -B -us -uc
    ;;
esac

if [ -f ../${PACKAGE}_${VERSION}_${ARCH}.changes ]; then
  mv -f ../${PACKAGE}_${VERSION}_${ARCH}.changes ../${PACKAGE}_${VERSION}_${ARCH}.changes.orig
  awk '$3!="debug" {print}' ../${PACKAGE}_${VERSION}_${ARCH}.changes.orig > ../${PACKAGE}_${VERSION}_${ARCH}.changes
  FILES=$(awk 'section == "files" { print "../"$5 } $1=="Files:" { section = "files" }' ../${PACKAGE}_${VERSION}_${ARCH}.changes)
  echo "Copying: ../${PACKAGE}_${VERSION}_${ARCH}.changes ${FILES} to ${TARGET_DIR}"
  ${CP} ../${PACKAGE}_${VERSION}_${ARCH}.changes ${FILES} ${TARGET_DIR}
fi
