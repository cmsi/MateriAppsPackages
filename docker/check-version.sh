#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd "$(dirname $0)"; pwd)

CODENAMES="$1"

. $SCRIPT_DIR/../config/version.sh
if [ -z "${CODENAMES}" ]; then
  for v in ${VERSIONS}; do
    CODENAMES="${CODENAMES} $(echo ${v} | cut -d/ -f1)"
  done
fi

for c in ${CODENAMES}; do
  for v in ${VERSIONS}; do
    if [ $(echo ${v} | cut -d/ -f1) = ${c} ]; then
      BASE=$(echo ${v} | cut -d/ -f2)
      LABEL=$(echo ${v} | cut -d: -f2)
      IMAGE="madev/${c}"
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} lsb_release -s -c
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search libboost-all-dev 2>&1 | grep libboost-all-dev
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} cmake --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search libeigen3-dev 2>&1 | grep libeigen3-dev
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search libfftw3-dev 2>&1 | grep libfftw3-dev
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} gcc --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} git --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search openjdk-11-jdk-headless 2>&1 | grep openjdk-11-jdk-headless
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search openjdk-21-jdk-headless 2>&1 | grep openjdk-21-jdk-headless
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search openjdk-25-jdk-headless 2>&1 | grep openjdk-25-jdk-headless
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} python3 --version 2> /dev/null | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search libgromacs-dev 2>&1 | grep libgromacs-dev
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search ovito 2>&1 | grep ovito
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} apt search xcrysden-data 2>&1 | grep xcrysden-data
    fi
  done
done
