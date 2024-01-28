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
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} gcc --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} cmake --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} git --version | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} python3 --version 2> /dev/null | head -1
      docker run --rm --name ${c}.$$ ${IMAGE}:${LABEL} python --version 2> /dev/null | head -1
    fi
  done
done
