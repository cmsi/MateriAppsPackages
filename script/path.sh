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

VERSION=$(head -1 ${PACKAGE_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

echo "PACKAGE: ${PACKAGE}"
echo "PACKAGE_DIR: ${PACKAGE_DIR}"
echo "VERSION: ${VERSION}"
echo "VERSION_BASE: ${VERSION_BASE}"

if [ -x /usr/bin/lsb_release ]; then
  if [ $(lsb_release -s -i) = 'Debian' -o $(lsb_release -s -i) = 'Ubuntu' ]; then
    if [ -z "${DATA_DIR}" ]; then
      DATA_DIR="${HOME}/malive/data"
    fi
    BUILD_DIR="$(pwd)/build"
    TARGET_DIR="${DATA_DIR}/pkg/$(lsb_release -s -c)"
    SOURCE_DIR="${DATA_DIR}/src"
    echo "BUILD_DIR: ${BUILD_DIR}"
    echo "TARGET_DIR: ${TARGET_DIR}"
    echo "SOURCE_DIR: ${SOURCE_DIR}"
  fi
fi
